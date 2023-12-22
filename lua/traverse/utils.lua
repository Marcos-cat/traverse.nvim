local Opts = require('traverse.options').get()

local Utils = {}

local helpers = require 'traverse.utils.helpers'
local to_letters = helpers.to_letters
Utils.checkbox = require 'traverse.utils.checkbox'

---@param win integer
function Utils.lines(win)
    local buf = vim.api.nvim_win_get_buf(win)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    return lines
end

---@class Reference
---@field link string
---@field tag string

---@param win integer
function Utils.get_all_references(win)
    local lines = Utils.lines(win)

    ---@type Reference[]
    local references = {}

    for _, line in ipairs(lines) do
        local _, _, tag, link = line:find '^%[(.-)%]: (%S+)'
        if tag and link then
            table.insert(references, { tag = tag, link = link })
        end
    end

    return references
end

---@param line string
---@param col integer
---@param pattern string
---@return boolean
---@return string? capture
function Utils.is_on_pattern(line, col, pattern)
    local i = 1
    while i <= #line do
        local start, finish, capture = line:find(pattern, i)

        if start and finish then
            if col + 1 >= start and col + 1 <= finish then
                return true, capture
            end

            i = finish + 1 -- luacheck:ignore
        else
            break
        end
    end

    return false
end

---@param text string
function Utils.is_heading(text)
    return text:match '^#%S+$' ~= nil
end

---@param heading_id string should include the `#` i.e. use `#my-heading` not `my-heading`
---@param win? integer
---@return boolean - if finding the heading was successful
function Utils.go_to_heading(heading_id, win)
    if win == nil then
        win = vim.api.nvim_get_current_win()
    end

    heading_id = heading_id:sub(2)

    local lines = Utils.lines(win)
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
function Utils.get_all_headings(lines)
    ---@type Heading[]
    local headings = {}

    for linenr, line in ipairs(lines) do
        local heading = select(3, line:find '^#+ (.*)$')

        if heading then
            table.insert(headings, { heading = heading, linenr = linenr })
        end
    end

    return headings
end

---@param path string
function Utils.is_url(path)
    return path:match '^https?://w*%.?.-' ~= nil
end

---@param path string
function Utils.file_exists(path)
    if path == '' then
        return false
    end

    local file = io.open(path, 'r')
    local exists = file ~= nil
    if exists then
        io.close(file)
    end
    return exists
end

--Determines if the filetype of the current buffer is in the provided table
function Utils.in_filetype()
    local current_ft = vim.o.filetype

    for _, ft in ipairs(Opts.fts or {}) do
        if ft == current_ft then
            return true
        end
    end

    return false
end

function Utils.get_cursor_file()
    ---@type string
    return vim.fn.expand '<cfile>'
end

---@param path string
function Utils.get_file_path(path)
    if path:sub(1, 1) == '/' then -- path is absolute
        return path
    end

    local dir_of_current_file = vim.fn.expand '%:h'
    return './' .. dir_of_current_file .. '/' .. path
end

---@param path string
function Utils.open_file(path)
    vim.cmd('edit ' .. path)
end

---@param link string
function Utils.open_in_browser(link)
    -- TODO this should be an option
    local cmd = 'open'

    cmd = cmd .. ' ' .. link
    vim.fn.jobstart(cmd)
end

return Utils
