function! s:OpenScratchPad(ftype) abort
  let scratchpad_name = g:scratchpad_path . '/scratchpad.' . a:ftype
  let scr_bufnum = bufnr(scratchpad_name)

  if scr_bufnum == -1
    " open the scratchpad
    exe 'vnew ' . scratchpad_name

    nnoremap <buffer> <Plug>(ToggleScratchPad) :<c-u>bdelete<CR>

    let dir = expand('%:p:h')
    if !isdirectory(dir)
      call mkdir(dir)
    endif
  else
    " Scratch buffer is already created. Check whether it is open
    " in one of the windows
    let scr_winnum = bufwinnr(scr_bufnum)
    if scr_winnum != -1
      " Jump to the window which has the scratchpad if we are not
      " already in that window
      if winnr() != scr_winnum
        exe scr_winnum . 'wincmd w'
      endif
    else
      exe 'leftabove vsplit +buffer' . scr_bufnum
    endif
  endif
endfunction

function! s:KilledScratchPad(ftype) abort
  let escaped_scratchpad_path = '\V' . escape(g:scratchpad_path, '\')
  if expand('%:p') =~? '\v.*[\\/]' . escaped_scratchpad_path . '\v[\\/]scratchpad\.\f+$' && &l:filetype is? a:ftype
    bdelete
    return 1
  else
    return 0
  endif
endfunction

function! scratchpad#ToggleScratchPad(ftype) abort
  " guess ftype if buffer had no file extension
  if !empty(a:ftype)
    let ftype = a:ftype
  else
    let pads = split(globpath(g:scratchpad_path, 'scratchpad.*'), '\n')
    if len(pads) > 0
      let ftype = matchstr(pads[0], '\vscratchpad\.\zs(.+)$')
    else
      let ftype = expand('%:e')
    endif
  endif

  if empty(ftype)
    let ftype = input('Enter filetype or leave empty to cancel. Scratchpad filetype: ', 'text', 'filetype')
  endif
  if empty(ftype)
    echoerr 'No filetype given. Scratchpad cancelled.'
    return
  endif
  let &filetype = ftype

  let NumberOfScratchPadWindows = 0
  windo let NumberOfScratchPadWindows += s:KilledScratchPad(ftype)
  if NumberOfScratchPadWindows == 0
    call s:OpenScratchPad(ftype)
  endif
endfunction
