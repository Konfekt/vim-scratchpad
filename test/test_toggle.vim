" Default configuration: a relative directory, filetype of the current buffer.
source <sfile>:p:h/helper.vim
call TestLoad()

edit foo.vim
call assert_equal('vim', &filetype)
let s:main = win_getid()

" open
call scratchpad#ToggleScratchPad(g:scratchpad_ftype)
let s:pad = getcwd() .. '/.scratchpads/scratchpad.vim'
call assert_equal(s:pad, expand('%:p'))
call assert_equal(2, winnr('$'))
call assert_equal('vim', &filetype)
call assert_false(&buflisted)
call assert_false(&swapfile)
call assert_equal('hide', &bufhidden)
call setline(1, 'note')

" close from the scratchpad itself: content is written
call scratchpad#ToggleScratchPad(g:scratchpad_ftype)
call assert_equal(1, winnr('$'))
call assert_equal(['note'], readfile(s:pad))

" reopen and close from another window
call scratchpad#ToggleScratchPad(g:scratchpad_ftype)
call assert_equal(s:pad, expand('%:p'))
call assert_equal(['note'], getline(1, '$'))
call win_gotoid(s:main)
call scratchpad#ToggleScratchPad(g:scratchpad_ftype)
call assert_equal(1, winnr('$'))
call assert_equal(s:main, win_getid())

" <Plug> mapping and default dsp mapping exist
call assert_match('ToggleScratchPad', maparg('dsp', 'n'))

call TestFinish()
