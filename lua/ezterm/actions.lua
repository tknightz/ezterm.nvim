local actions = require('telescope.actions')
local ezterm = require('ezterm')
local transform_mod = require('telescope.actions.mt').transform_mod


local M = {}


local function change_direction(prompt_bufnr, direction)
    local entry = actions.get_selected_entry(prompt_bufnr)
    if not entry then
        return
    end

    ezterm.change_direction(entry.bufnr, direction)
end

M.open_term = function(prompt_bufnr, enter_insert)
    local entry = actions.get_selected_entry(prompt_bufnr)
    if not entry then
        return
    end
    ezterm.open_term(entry.bufnr, enter_insert)
end

M.change_direction_center = function(prompt_bufnr)
    return change_direction(prompt_bufnr, "center")
end

M.change_direction_top = function(prompt_bufnr)
    return change_direction(prompt_bufnr, "top")
end

M.change_direction_bottom = function(prompt_bufnr)
    return change_direction(prompt_bufnr, "bottom")
end

M.change_direction_left = function(prompt_bufnr)
    return change_direction(prompt_bufnr, "left")
end

M.change_direction_right = function(prompt_bufnr)
    return change_direction(prompt_bufnr, "right")
end

return transform_mod(M)
