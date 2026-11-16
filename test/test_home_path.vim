" A g:scratchpad_path starting with ~ is relative to $HOME, not to the
" working directory.
source <sfile>:p:h/helper.vim
let $HOME = g:test_tmp .. '/home'
call mkdir($HOME, 'p')
let g:scratchpad_path = '~/pads'
call TestLoad()

edit foo.txt
call scratchpad#ToggleScratchPad('')
call assert_equal($HOME .. '/pads/scratchpad.txt', expand('%:p'))
call assert_false(isdirectory(getcwd() .. '/~'))

call TestFinish()
