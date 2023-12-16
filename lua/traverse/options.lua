---@class TraverseOpts
---@field fts? string[]
---@field confirm? table<string, boolean>
local TraverseOpts = {
    fts = { 'markdown', 'text' },
    confirm = { browser = true, new_file = true, open_file = false },
}

local M = {}

---@param opts TraverseOpts
function M.set(opts)
    TraverseOpts = vim.tbl_deep_extend('force', TraverseOpts, opts)
end

M.get = function()
    return TraverseOpts
end

return M
