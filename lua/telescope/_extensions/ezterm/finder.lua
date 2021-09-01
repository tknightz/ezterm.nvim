local finders = require('telescope.finders')
local entry_display = require('telescope.pickers.entry_display')

local M = {}

M.ezterm_finder = function(opts, terms)
    local displayer = entry_display.create({
        separator = " ",
        items = {
            { width = 40 },
            { width = 18 },
            { remaining = true },
        },
    })

    local make_display = function(entry)
        local space = ""
        for i = 1, (5 - #tostring(entry.id)) do
            space = space .. " "
        end
        print(entry.id .. space)
        return displayer({
            entry.id .. space .. " │ " ..entry.name,
        })
    end

    return finders.new_table {
        results = terms,
        theme = "dropdown",
        entry_maker = function(term)
            term.value = term.id
            term.ordinal = term.name
            term.display = make_display
            return term
        end
    }
end


return M
