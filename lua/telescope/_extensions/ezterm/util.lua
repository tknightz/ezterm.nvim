local ok, ezterm = pcall(require, "ezterm")

if not ok then
	vim.cmd[[PackerLoad ezterm.nvim]]
	ezterm = require("ezterm")
end


local M = {}

M.get_terminals = function()
	local terms_table = ezterm.get_terminals()
	local terms = {}
	for key, term in pairs(terms_table) do
		table.insert(terms, {
			bufnr = term.bufnr,
			id = key,
			name = term.name
		})
	end
	return terms
end


M.get_term_by_bufnr = function(bufnr)
	return ezterm.get_terminals()[bufnr]
end


return M
