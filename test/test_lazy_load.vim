" Loading the plugin does not source autoload/scratchpad.vim; that only
" happens on the first toggle.
source <sfile>:p:h/helper.vim
call TestLoad()
call assert_false(exists('*scratchpad#ToggleScratchPad'))
call assert_equal(1, len(filter(split(execute('scriptnames'), "\n"), 'v:val =~# "plugin[\\/]scratchpad.vim"')))
call assert_equal(0, len(filter(split(execute('scriptnames'), "\n"), 'v:val =~# "autoload[\\/]scratchpad.vim"')))
call TestFinish()
