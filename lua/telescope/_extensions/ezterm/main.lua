local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local action_state = require('telescope.actions.state')
local ezaction = require('ezterm.actions')
local action_set = require('telescope.actions.set')

local _actions = require('telescope._extensions.ezterm.actions')
local _finder = require('telescope._extensions.ezterm.finder')
local _util = require('telescope._extensions.ezterm.util')

local M = {}

local state = {}

M.setup = function(opts)
	if opts then
		state.previewer = opts.previewer
		state.theme = opts.theme
		state.enter_insert = opts.enter_insert
		config = vim.tbl_extend("force", conf, opts)
	end
end

local function show_previewer(opts)
	if state.previewer or state.previewer == nil then
		return conf.grep_previewer(opts)
	end
	return state.previewer
end

M.ezterm = function(opts)
	pickers.new(opts, {
		prompt_title = "Ezterm",
		results_title = "Terms",
		sorter = conf.file_sorter(opts),
		finder = _finder.ezterm_finder(opts, _util.get_terminals()),
		previewer = show_previewer(opts),
		theme = "dropdown",
		attach_mappings = function(prompt_bufnr, map)

			local on_term_selected = function()
				ezaction.open_term(prompt_bufnr, state.enter_insert)
			end

			local refresh_terms = function()
				local theme_set = ""
				if state.theme then
					theme_set = "theme=get_" .. state.theme
				end
				local cmd = "Telescope ezterm " .. theme_set
				vim.cmd(cmd)
			end

			local refresh_on_fly = function()
				local picker = action_state.get_current_picker(prompt_bufnr)
				local finder = _finder.ezterm_finder(opts, _util.get_terminals())
				picker:refresh(finder, { reset_prompt = true })
			end

			ezaction.change_direction_top:enhance({ post = refresh_terms })
			ezaction.change_direction_left:enhance({ post = refresh_terms })
			ezaction.change_direction_right:enhance({ post = refresh_terms })
			ezaction.change_direction_bottom:enhance({ post = refresh_terms })
			ezaction.change_direction_center:enhance({ post = refresh_terms })
			_actions.rename_term:enhance({ post = refresh_on_fly })

			map('i', '<C-Up>', ezaction.change_direction_top)
			map('i', '<C-Left>', ezaction.change_direction_left)
			map('i', '<C-Right>', ezaction.change_direction_right)
			map('i', '<C-Down>', ezaction.change_direction_bottom)
			map('i', '<C-i>', ezaction.change_direction_center)
			map('i', '<C-n>', _actions.rename_term)
			map('i', '<CR>', ezaction.open_term)

			action_set.select:replace(on_term_selected)
			return true
		end
	}):find()
end


return M
