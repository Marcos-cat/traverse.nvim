local u = require 'traverse.utils'
local ask = require 'traverse.ask'

local Traverse = {}

function Traverse.traverse()
    u.go_to_markdown_link()

    if not u.in_filetype() then
        return
    end

    local link_name = u.get_cursor_file()
    local file_path = u.get_file_path()

    if u.file_exists(file_path) then
        if ask.confirm_open_file(link_name) then
            u.open_file(file_path)
        end
        return
    end

    if u.is_link(link_name) then
        if ask.confirm_open_browser() then
            u.open_in_browser(link_name)
        end
        return
    end

    if ask.confirm_new_file(link_name) then
        u.open_file(file_path)
    end
end

return Traverse
