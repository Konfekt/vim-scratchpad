" A g:scratchpad_path containing a space works and gets the scratchpad
" buffer settings.
source <sfile>:p:h/helper.vim
let g:scratchpad_path = 'my pads'
call TestLoad()

edit foo.txt
call scratchpad#ToggleScratchPad('')
call assert_equal(getcwd() .. '/my pads/scratchpad.txt', expand('%:p'))
call assert_false(&buflisted)
call scratchpad#ToggleScratchPad('')
call assert_equal(1, winnr('$'))

call TestFinish()
