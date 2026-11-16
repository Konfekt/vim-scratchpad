" g:scratchpad_ftype fixes filetype and extension; the dsp mapping is not
" added when the user maps <Plug>(ToggleScratchPad) themselves.
source <sfile>:p:h/helper.vim
let g:scratchpad_ftype = 'markdown'
nmap <Leader>s <Plug>(ToggleScratchPad)
call TestLoad()

call assert_equal('', maparg('dsp', 'n'))
edit foo.vim
execute "normal \<Plug>(ToggleScratchPad)"
call assert_equal(getcwd() .. '/.scratchpads/scratchpad.markdown', expand('%:p'))
call assert_equal('markdown', &filetype)
execute "normal \<Plug>(ToggleScratchPad)"
call assert_equal(1, winnr('$'))

call TestFinish()
