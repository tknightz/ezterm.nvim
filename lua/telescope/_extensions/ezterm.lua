local has_telescope, telescope = pcall(require, 'telescope')
local main = require('telescope._extensions.ezterm.main')


if not has_telescope then
    error('Require a Telescope plugin. Make sure you already installed it!')
end


return telescope.register_extension{
    setup = main.setup,
    exports = {
        ezterm = main.ezterm,
        find = main.ezterm
    }
}
