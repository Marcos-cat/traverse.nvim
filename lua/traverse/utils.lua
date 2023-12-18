local Opts = require('traverse.options').get()

local Utils = {}

---@param arr integer[]
local function scanadd(arr)
    for i, val in ipairs(arr) do
        if i ~= 1 then
            arr[i] = val + arr[i - 1]
        end
    end

    return arr
end

---@param line string
---@param win integer
---@param pos integer[]
---@return boolean
local function go_to_parenthesis(line, win, pos)
    local col = pos[2]

    local paren_index = line:find('%]', col + 1)

    if paren_index == nil then
        return false
    end

    vim.api.nvim_win_set_cursor(win, { pos[1], paren_index })
    return true
end

---@param line string
---@param col integer
---@return boolean
local function is_between_brackets(line, col)
    ---@type integer[]
    local bitmask = {}

    for i = 1, #line do
        local c = line:sub(i, i)

        if c == '[' then
            bitmask[i] = 1
        elseif c == ']' then
            bitmask[i] = -1
        else
            bitmask[i] = 0
        end
    end

    bitmask = scanadd(bitmask) -- And the win goes to functional!!! #Uiua

    return bitmask[col + 1] == 1
end

---@param str string
---@return string
local function to_letters(str)
    local alphabet = 'qwertyuiopasdfghjklzxcvbnm'
    str = str:lower()

    local out = ''

    for i = 1, #str do
        local letter = str:sub(i, i)

        if alphabet:find(letter, nil, true) ~= nil then
            out = out .. letter
        end
    end

    return out
end

---@param text string
function Utils.is_heading(text)
    return text:sub(1, 1) == '#'
end

---@param heading_id string should include the `#` i.e. use `#my-heading` not `my-heading`
---@param win integer
---@return boolean if finding the heading was successful
function Utils.go_to_heading(heading_id, win)
    heading_id = heading_id:sub(2)

    local buf = vim.api.nvim_win_get_buf(win)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local headings = Utils.get_all_headings(lines)

    for _, val in ipairs(headings) do
        if to_letters(val.heading) == to_letters(heading_id) then
            vim.api.nvim_win_set_cursor(win, { val.linenr, 0 })

            return true
        end
    end

    return false
end

---@class Heading
---@field heading string
---@field linenr integer

---@param lines string[]
---@return Heading[]
function Utils.get_all_headings(lines)
    ---@type Heading[]
    local headings = {}

    for linenr, line in ipairs(lines) do
        if line:sub(1, 1) == '#' then
            local space = line:find ' '

            if space ~= nil then
                local heading = line:sub(space + 1)

                headings[#headings + 1] = { heading = heading, linenr = linenr }
            end
        end
    end

    return headings
end

---@param path string
---@return boolean
function Utils.is_url(path)
    return path:sub(1, 4) == 'http'
end

---@param path string
---@return boolean
function Utils.file_exists(path)
    local file = io.open(path, 'r')
    local exists = file ~= nil
    if exists then
        io.close(file)
    end
    return exists
end

---@param win integer
---@return boolean found_link if finding a link was successful
function Utils.go_to_markdown_link(win)
    local line = vim.api.nvim_get_current_line()
    local pos = vim.api.nvim_win_get_cursor(win)

    if is_between_brackets(line, pos[2]) then
        return go_to_parenthesis(line, win, pos)
    end

    return false
end

--Determines if the filetype of the current buffer is in the provided table
function Utils.in_filetype()
    local current_ft = vim.o.filetype

    for _, ft in ipairs(Opts.fts) do
        if ft == current_ft then
            return true
        end
    end

    return false
end

---@return string
function Utils.get_cursor_file()
    return vim.fn.expand '<cfile>'
end

---@return string
function Utils.get_file_path()
    return './' .. vim.fn.expand '%:h' .. '/' .. Utils.get_cursor_file()
end

---@param path string
function Utils.open_file(path)
    vim.cmd('e ' .. path)
end

---@param link string
function Utils.open_in_browser(link)
    local cmd = 'open'
    cmd = cmd .. ' ' .. link
    vim.fn.jobstart(cmd)
end

---@param line string
---@return boolean
function Utils.is_on_checkbox(line)
    return line:sub(1, 3) == '- [' and line:sub(5, 5) == ']'
end

---@param line string
---@return boolean
function Utils.checkbox_is_checked(line)
    return Utils.is_on_checkbox(line) and line:sub(1, 5) == '- [x]'
end

---@param keys string
local function input(keys)
    vim.api.nvim_feedkeys(keys, 'n', true)
end

function Utils.toggle_checkbox()
    local line = vim.api.nvim_get_current_line()

    if not Utils.is_on_checkbox(line) then
        return
    end

    if Utils.checkbox_is_checked(line) then
        input 'mz_f[lr `z'
    else
        input 'mz_f[lrx`z'
    end
end

return Utils
