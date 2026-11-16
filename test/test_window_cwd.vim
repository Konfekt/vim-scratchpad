" The scratchpad goes into the working directory of the window it is toggled
" from, even if another window has a different local directory.
source <sfile>:p:h/helper.vim
call TestLoad()

let s:cwd = getcwd()
call mkdir('other', 'p')
edit foo.txt
let s:main = win_getid()
botright split bar.txt
lcd other
call win_gotoid(s:main)

call scratchpad#ToggleScratchPad('')
call assert_equal(s:cwd .. '/.scratchpads/scratchpad.txt', expand('%:p'))

call TestFinish()
