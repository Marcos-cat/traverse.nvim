local cmds = {
    Traverse = function()
        require('traverse.main').traverse()
    end,
}

local M = {}

M.setup = function(opts)
    require('traverse.options').set(opts)

    for cmd, func in pairs(cmds) do
        vim.api.nvim_create_user_command(cmd, func, {})
    end
end

return M
