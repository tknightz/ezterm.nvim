if !has('nvim-0.5')
  echoerr 'You need neovim nightly to run this plugin'
  finish
endif

command! -nargs=? Ezterm lua require('ezterm').new_term(<q-args>, true)
command! EztermFind lua require('ezterm').ezterm_command()
