local options = {
    fts = { 'markdown', 'text' },
    confirm = { browser = true, new_file = true, open_file = false },
}

local M = {}

M.set = function(opts)
    options = vim.tbl_deep_extend('force', options, opts)
end

M.get = function()
    return options
end

return M
