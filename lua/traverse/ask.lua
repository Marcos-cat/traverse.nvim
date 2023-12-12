local M = {}
local opts = require 'traverse.options'

M.confirm_open_browser = function()
    if not opts.get().confirm.browser then
        return true
    end

    return vim.fn.confirm(
        'Would you like to open in a browser?',
        '&Yes\n&No',
        1
    ) == 1
end

M.confirm_new_file = function(name) ---@param name string
    if not opts.get().confirm.new_file then
        return true
    end

    return vim.fn.confirm(
        'Would you like to create: ' .. name .. ' ?',
        '&Yes\n&No',
        1
    ) == 1
end

M.confirm_open_file = function(name) ---@param name string
    if not opts.get().confirm.open_file then
        return true
    end

    return vim.fn.confirm(
        'Would you like to go to: ' .. name .. ' ?',
        '&Yes\n&No',
        1
    ) == 1
end

return M
