local Helpers = {}

function Helpers.to_letters(str)
    return tostring(str):gsub('%A', ''):lower()
end

function Helpers.to_letters_eq(a, b)
    return Helpers.to_letters(a) == Helpers.to_letters(b)
end

return Helpers
