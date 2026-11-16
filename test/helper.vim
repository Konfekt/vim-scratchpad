" Shared setup for the headless tests: an isolated temporary working
" directory, the plugin on the runtimepath, and a function that writes the
" result to $SCRATCHPAD_TEST_LOG and quits.
set hidden shortmess+=A
filetype on
let s:root = fnamemodify(expand('<sfile>:p:h:h'), ':p')
execute 'set runtimepath^=' .. fnameescape(s:root)
let g:test_tmp = resolve(fnamemodify(tempname(), ':p'))
call mkdir(g:test_tmp .. '/work', 'p')
execute 'cd' fnameescape(g:test_tmp .. '/work')

function! g:TestFinish() abort
  call writefile(empty(v:errors) ? ['ok'] : v:errors, $SCRATCHPAD_TEST_LOG)
  qall!
endfunction

function! g:TestLoad() abort
  runtime plugin/scratchpad.vim
endfunction
