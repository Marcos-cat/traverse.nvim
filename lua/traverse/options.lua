local options = {
    fts = { 'markdown', 'text' },
    logging = false,
}

local M = {}

M.set = function(opts)
    options = vim.tbl_deep_extend('force', options, opts)
end

M.get = function()
    return options
end

return M
