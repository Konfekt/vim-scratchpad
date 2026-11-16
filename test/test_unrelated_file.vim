" A file named scratchpad.* outside the scratchpad directory is an ordinary
" buffer: listed, swapfile, default bufhidden.
source <sfile>:p:h/helper.vim
call TestLoad()

call mkdir('elsewhere', 'p')
edit elsewhere/scratchpad.txt
call assert_true(&buflisted)
call assert_equal('', &bufhidden)

call TestFinish()
