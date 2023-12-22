local Checkbox = {}

---@param line string
---@return boolean?
function Checkbox.get(line)
    local _, _, check = line:find '^%- %[([ x])%]'
    if check ~= nil then
        return check == 'x'
    end
end

---@param keys string
local function input(keys)
    vim.api.nvim_feedkeys(keys, 'n', true)
end

function Checkbox.toggle()
    local line = vim.api.nvim_get_current_line()

    local checked = Checkbox.get(line)

    if checked == nil then
        return
    end

    if checked then
        input 'mz_f[lr `z'
    else
        input 'mz_f[lrx`z'
    end
end

return Checkbox
