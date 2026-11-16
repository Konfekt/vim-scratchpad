" An absolute g:scratchpad_path that already exists is used as is.
source <sfile>:p:h/helper.vim
let g:scratchpad_path = g:test_tmp .. '/pads/'
call mkdir(g:scratchpad_path, 'p')
call TestLoad()

edit foo.txt
call scratchpad#ToggleScratchPad('')
call assert_equal(g:test_tmp .. '/pads/scratchpad.txt', expand('%:p'))
call assert_false(&buflisted)
call assert_equal('hide', &bufhidden)
" toggling from another window closes it
wincmd p
call scratchpad#ToggleScratchPad('')
call assert_equal(1, winnr('$'))

call TestFinish()
