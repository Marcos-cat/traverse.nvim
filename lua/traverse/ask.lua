local M = {}

M.confirm_open_browser = function()
    return vim.fn.confirm(
        'Would you like to open in a browser?',
        '&Yes\n&No',
        1
    ) == 1
end

M.confirm_make_file = function(name) ---@param name string
    return vim.fn.confirm(
        'Would you like to create: ' .. name .. ' ?',
        '&Yes\n&No',
        1
    ) == 1
end

return M
