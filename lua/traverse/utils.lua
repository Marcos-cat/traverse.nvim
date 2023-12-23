local Opts = require('traverse.options').get()

local Utils = {}

Utils.checkbox = require 'traverse.utils.checkbox'
local to_letters_eq = require('traverse.utils.helpers').to_letters_eq

---@param win integer
function Utils.all_lines(win)
    local buf = vim.api.nvim_win_get_buf(win)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    return lines
end

---@param win integer
---@param tag string
---@return string?
function Utils.get_reference_link(win, tag)
    if not tag or tag == '' then
        return
    end

    local lines = Utils.all_lines(win)

    for _, line in ipairs(lines) do
        local _, _, reference_tag, link = line:find '^%[(.-)%]: (%S+)'
        if reference_tag == tag then
            return tostring(link)
        end
    end
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
    if not win then
        win = vim.api.nvim_get_current_win()
    end

    heading_id = heading_id:sub(2)

    local lines = Utils.all_lines(win)
    local linenr = Utils.get_heading_linenr(lines, heading_id)
    if linenr then
        vim.api.nvim_win_set_cursor(win, { linenr, 0 })
        return true
    end

    return false
end

---@param lines string[]
---@param heading_text string
function Utils.get_heading_linenr(lines, heading_text)
    if not heading_text or heading_text == '' then
        return
    end

    for linenr, line in ipairs(lines) do
        local _, _, text = line:find '^#+ (.*)$'

        if to_letters_eq(text, heading_text) then
            return linenr
        end
    end
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
