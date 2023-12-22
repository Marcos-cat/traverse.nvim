local Helpers = {}

---@param str string
function Helpers.to_letters(str)
    return str:gsub('%A', ''):lower()
end

---@param arr integer[]
function Helpers.scanadd(arr)
    for i, val in ipairs(arr) do
        if i ~= 1 then
            arr[i] = val + arr[i - 1]
        end
    end

    return arr
end

return Helpers
