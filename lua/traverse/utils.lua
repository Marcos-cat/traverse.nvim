local opts = require 'traverse.options'

local function scanadd(arr) ---@param arr integer[]
    for i, val in ipairs(arr) do
        if i ~= 1 then
            arr[i] = val + arr[i - 1]
        end
    end

    return arr
end

local function go_to_parenthesis()
    local win = vim.api.nvim_get_current_win()
    local pos = vim.api.nvim_win_get_cursor(win)
    local col = pos[2]
    local line = vim.api.nvim_get_current_line()

    local paren_i = line:find('%]', col + 1)

    if not paren_i then
        return false
    end

    vim.api.nvim_win_set_cursor(win, { pos[1], paren_i })
end

local function is_between_brackets()
    local col = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[2]
    local line = vim.api.nvim_get_current_line()

    local bitmask = {} ---@type integer[]

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

local Utils = {}

function Utils.is_link(path) ---@param path string
    return path:sub(0, 4) == 'http'
end

function Utils.file_exists(name) ---@param name string
    local file = io.open(name, 'r')
    local exists = file ~= nil
    if exists then
        io.close(file)
    end
    return exists
end

--Returns `true` if finding a link was successful, otherwise `false`
function Utils.go_to_markdown_link()
    if is_between_brackets() then
        return go_to_parenthesis()
    end

    return false
end

--Determines if the filetype of the current buffer is in the provided table
function Utils.in_filetype()
    local current_ft = vim.o.filetype

    for _, ft in ipairs(opts.get().fts) do
        if ft == current_ft then
            return true
        end
    end

    return false
end

function Utils.get_cursor_file() ---@return string
    return vim.fn.expand '<cfile>'
end

function Utils.get_file_path() ---@return string
    return './' .. vim.fn.expand '%:h' .. '/' .. Utils.get_cursor_file()
end

function Utils.open_file(path) ---@param path string
    vim.cmd('e ' .. path)
end

function Utils.open_in_browser(link) ---@param link string
    local cmd = 'open'
    cmd = cmd .. ' ' .. link
    vim.fn.jobstart(cmd)
end

function Utils.is_on_checkbox()
    local line = vim.api.nvim_get_current_line()
    return line:sub(1, 3) == '- [' and line:sub(5, 5) == ']'
end

function Utils.checkbox_is_checked()
    local line = vim.api.nvim_get_current_line()
    return Utils.is_on_checkbox() and line:sub(1, 5) == '- [x]'
end

local function input(keys) ---@param keys string
    vim.api.nvim_feedkeys(keys, 'n', true)
end

function Utils.toggle_checkbox()
    if not Utils.is_on_checkbox() then
        return
    end

    if Utils.checkbox_is_checked() then input('mz_f[lr `z') else input('mz_f[lrx`z') end
end

return Utils
