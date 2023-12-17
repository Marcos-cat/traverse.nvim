local Utils = require 'traverse.utils'
local Ask = require 'traverse.ask'

local Traverse = {}

function Traverse.traverse()
    Utils.go_to_markdown_link()

    if not Utils.in_filetype() then
        return
    end

    local link_name = Utils.get_cursor_file()
    local file_path = Utils.get_file_path()

    if Utils.file_exists(file_path) then
        if Ask.confirm_open_file(link_name) then
            Utils.open_file(file_path)
        end
        return
    end

    if Utils.is_url(link_name) then
        local url = link_name

        if Ask.confirm_open_browser() then
            Utils.open_in_browser(url)
        end
        return
    end

    if Utils.is_heading(link_name) then
        local heading_id = link_name

        if Utils.go_to_heading(heading_id) then
            return
        end
    end

    if Ask.confirm_new_file(link_name) then
        Utils.open_file(file_path)
    end
end

return Traverse
