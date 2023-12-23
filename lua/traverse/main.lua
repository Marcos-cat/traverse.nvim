local Utils = require 'traverse.utils'
local Ask = require 'traverse.ask'

local Traverse = {}

---@param link string
function Traverse.try_link(link)
    local file_path = Utils.get_file_path(link)

    if Utils.is_heading(link) then
        local heading_id = link

        if Utils.go_to_heading(heading_id) then
            return
        end
    end

    if Utils.file_exists(file_path) then
        if Ask.confirm_open_file(link) then
            Utils.open_file(file_path)
        end
        return
    end

    if Utils.is_url(link) then
        local url = link

        if Ask.confirm_open_browser(url) then
            Utils.open_in_browser(url)
        end
        return
    end

    if Ask.confirm_new_file(link) then
        Utils.open_file(file_path)
    end
end

function Traverse.traverse()
    if not Utils.in_filetype() then
        return
    end

    local line = vim.api.nvim_get_current_line()
    local win = vim.api.nvim_get_current_win()
    local cursor_pos = vim.api.nvim_win_get_cursor(win) -- `0` for current window
    local col = cursor_pos[2]

    local link_pattern = '%[.-%]%(%s*(%S*).-%)'
    local _, link_name = Utils.is_on_pattern(line, col, link_pattern)

    if link_name then
        Traverse.try_link(link_name)
        return
    end

    local reference_pattern = '%[.-%]%[%s*(%S*)%s*.-%]'
    local _, tag = Utils.is_on_pattern(line, col, reference_pattern)

    local link = Utils.get_reference_link(win, tag or '')
    if link then
        Traverse.try_link(link)
        return
    end

    Traverse.try_link(Utils.get_cursor_file())
end

return Traverse
