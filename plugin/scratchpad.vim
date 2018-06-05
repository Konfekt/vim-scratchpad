scriptencoding utf-8

" LICENCE PUBLIQUE RIEN À BRANLER
" Version 1, Mars 2009
"
" Copyright (C) 2009 Sam Hocevar
" 14 rue de Plaisance, 75014 Paris, France
"
" La copie et la distribution de copies exactes de cette licence sont
" autorisées, et toute modification est permise à condition de changer
" le nom de la licence.
"
" CONDITIONS DE COPIE, DISTRIBUTON ET MODIFICATION
" DE LA LICENCE PUBLIQUE RIEN À BRANLER
"
" 0. Faites ce que vous voulez, j’en ai RIEN À BRANLER.

if exists('g:loaded_scratchpad')
  finish
endif
let g:loaded_scratchpad = 1

let s:keepcpo         = &cpo
set cpo&vim
" ------------------------------------------------------------------------------

nnoremap <silent> <Plug>(ToggleScratchPad) :<c-u>call scratchpad#ToggleScratchPad(&l:filetype)<CR>

if empty(maparg('dsp','n')) && !hasmapto('<Plug>(ToggleScratchPad)', 'n')
    silent! nmap dsp <Plug>(ToggleScratchPad)
endif

if !(exists('g:scratchpad_path'))
  let g:scratchpad_path = '.scratchpads'
endif

augroup scratchpad
  autocmd!
  execute 'autocmd BufNewFile,BufRead '. g:scratchpad_path . '/scratchpad.* setlocal bufhidden=hide nobuflisted noswapfile'
  execute 'autocmd BufLeave ' . g:scratchpad_path . '/scratchpad.* update'
augroup END

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo
