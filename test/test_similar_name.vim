" A scratchpad whose name is a prefix of an existing one (scratchpad.c next to
" scratchpad.cpp) is opened as its own buffer, not mistaken for the other.
source <sfile>:p:h/helper.vim
call TestLoad()

let s:dir = getcwd() .. '/.scratchpads/'
call scratchpad#ToggleScratchPad('cpp')
call assert_equal(s:dir .. 'scratchpad.cpp', expand('%:p'))
call scratchpad#ToggleScratchPad('cpp')
call assert_equal(1, winnr('$'))

call scratchpad#ToggleScratchPad('c')
call assert_equal(s:dir .. 'scratchpad.c', expand('%:p'))
call assert_equal('c', &filetype)
call assert_equal(2, winnr('$'))

call TestFinish()
