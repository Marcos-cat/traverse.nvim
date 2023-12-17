local Ask = {}
local Opts = require('traverse.options').get()

Ask.confirm_open_browser = function()
    if Opts.confirm.browser == false then
        return true
    end

    return vim.fn.confirm(
        'Would you like to open in a browser?',
        '&Yes\n&No',
        1
    ) == 1
end

---@param name string
Ask.confirm_new_file = function(name)
    if Opts.confirm.new_file == false then
        return true
    end

    return vim.fn.confirm(
        'Would you like to create: ' .. name .. ' ?',
        '&Yes\n&No',
        1
    ) == 1
end

---@param name string
Ask.confirm_open_file = function(name)
    if Opts.confirm.open_file == false then
        return true
    end

    return vim.fn.confirm(
        'Would you like to go to: ' .. name .. ' ?',
        '&Yes\n&No',
        1
    ) == 1
end

return Ask
