" A scratchpad whose extension does not imply its filetype (here
" scratchpad.python) keeps that filetype when it is toggled open again after
" having been closed, so that toggling keeps working.
source <sfile>:p:h/helper.vim
let g:scratchpad_ftype = 'python'
call TestLoad()

edit foo.txt
let s:main = win_getid()
let s:pad = getcwd() .. '/.scratchpads/scratchpad.python'
for s:i in range(3)
  call scratchpad#ToggleScratchPad(g:scratchpad_ftype)
  call assert_equal(s:pad, expand('%:p'), 'open #' .. s:i)
  call assert_equal('python', &filetype, 'open #' .. s:i)
  call assert_equal(2, winnr('$'), 'open #' .. s:i)
  call scratchpad#ToggleScratchPad(g:scratchpad_ftype)
  call assert_equal(1, winnr('$'), 'close #' .. s:i)
  call assert_equal(s:main, win_getid(), 'close #' .. s:i)
endfor

call TestFinish()
