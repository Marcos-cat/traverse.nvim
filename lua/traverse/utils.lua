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

local M = {}

M.is_link = function(path) ---@param path string
    return path:sub(0, 4) == 'http'
end

M.file_exists = function(name) ---@param name string
    local file = io.open(name, 'r')
    local exists = file ~= nil
    if exists then
        io.close(file)
    end
    return exists
end

--Returns `true` if finding a link was successful, otherwise `false`
M.go_to_markdown_link = function()
    if is_between_brackets() then
        return go_to_parenthesis()
    end

    return false
end

--Determines if the filetype of the current buffer is in the provided table
M.in_filetype = function()
    local current_ft = vim.o.filetype

    for _, ft in ipairs(opts.get().fts) do
        if ft == current_ft then
            return true
        end
    end

    return false
end

M.get_cursor_file = function() ---@return string
    return vim.fn.expand '<cfile>'
end

M.get_file_path = function() ---@return string
    return './' .. vim.fn.expand '%:h' .. '/' .. M.get_cursor_file()
end

M.open_file = function(path)
    vim.cmd('e ' .. path)
end

M.open_in_browser = function(link) ---@param link string
    local cmd = 'open'
    cmd = cmd .. ' ' .. link
    vim.fn.jobstart(cmd)
end

M.is_on_checkbox = function()
    local line = vim.api.nvim_get_current_line()
    return line:sub(1, 3) == '- [' and line:sub(5, 5) == ']'
end

M.checkbox_is_checked = function()
    local line = vim.api.nvim_get_current_line()
    return M.is_on_checkbox() and line:sub(1, 5) == '- [x]'
end

M.toggle_checkbox = function()
    if not M.is_on_checkbox() then
        return
    end

    if M.checkbox_is_checked() then
        vim.api.nvim_feedkeys('mz_f[lr `z', 'n', true)
    else
        vim.api.nvim_feedkeys('mz_f[lrx`z', 'n', true)
    end
end

return M
