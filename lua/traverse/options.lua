---@class TraverseOpts
---@field fts? string[]
---@field confirm? {browser?: boolean, new_file?: boolean, open_file?: boolean}
local TraverseOpts = {
    fts = { 'markdown', 'text' },
    confirm = {
        browser = true,
        new_file = true,
        open_file = false,
    },
}

return {
    get = function()
        return TraverseOpts
    end,

    ---@param val TraverseOpts?
    set = function(val)
        TraverseOpts = vim.tbl_deep_extend('force', TraverseOpts, val or {})
    end,
}
