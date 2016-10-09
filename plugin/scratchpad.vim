if exists('g:loaded_scratchpad')
  finish
endif
let g:loaded_scratchpad = 1

" See https://github.com/tarruda/dot-files/blob/master/vim/vimrc
nnoremap <silent> <Plug>(ToggleScratchPad) :<c-u>call scratchpad#ToggleScratchPad(&l:filetype)<CR>

if empty(maparg('dsp','n')) && !hasmapto('<Plug>(ToggleScratchPad)', 'n')
    silent! nmap dsp <Plug>(ToggleScratchPad)
endif

if !(exists('g:scratchpad_path'))
  let g:scratchpad_path = '.scratchpads'
endif

augroup scratchpad
  autocmd!
  execute 'autocmd BufNewFile,BufRead '. g:scratchpad_path . '/scratchpad.* setlocal bufhidden=hide buflisted noswapfile'
augroup END
