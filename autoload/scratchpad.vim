" slash adapted to the OS
let s:slash = (exists('+shellslash') && !&shellslash ? '\' : '/')

function! s:OpenScratchPad(ftype, extension) abort
  let cwd = getcwd()
  let scratchpad_dir =
        \ ((g:scratchpad_path =~# fnamemodify(g:scratchpad_path, ':p')) ? '' : cwd..s:slash)..
        \  g:scratchpad_path
  let scratchpad_path = scratchpad_dir..s:slash..'scratchpad.'..a:extension
  let scr_bufnum = bufnr(scratchpad_path)

  if scr_bufnum == -1
    if !isdirectory(scratchpad_dir)
      call mkdir(scratchpad_dir, 'p')
    endif
    " open the scratchpad
    exe s:SplitWindow() 'new' fnameescape(scratchpad_path)
    let &l:filetype = a:ftype
    exe 'lchdir' fnameescape(cwd)

    nnoremap <silent><buffer> <Plug>(ToggleScratchPad) :<C-U>update<bar>bdelete<CR>
  else
    " Scratch buffer is already created. Check whether it is open
    " in one of the windows
    let scr_winnum = bufwinnr(scr_bufnum)
    if scr_winnum != -1
      " Jump to the window displaying the scratchpad if not already there.
      if winnr() != scr_winnum
        exe scr_winnum..'wincmd w'
      endif
    else
      exe s:SplitWindow() 'split +buffer'..scr_bufnum
    endif
  endif
endfunction

function! s:SplitWindow()
  let height = winheight(0) * 5
  let width = winwidth(0) * 2
  if height > width
    return 'aboveleft '
  else
    return 'topleft vertical'
  endif
endfunction

function! s:KilledScratchPad(ftype) abort
  let escaped_scratchpad_path = '\V'..escape(g:scratchpad_path, '\')
  if expand('%:p') =~? '\v.*[\\/]'..escaped_scratchpad_path..'\v[\\/]scratchpad\.\f+$' && &l:filetype is? a:ftype
    update
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
    let extension = ftype
  else
    let ftype = &l:filetype
    let extension = expand('%:e')
    if empty(extension)
      let extension = ftype
    endif
  endif

  if empty(ftype)
    let ftype = input('Enter filetype or leave empty to cancel. Scratchpad filetype: ', 'text', 'filetype')
    let extension = ftype
  endif
  if empty(ftype)
    echoerr 'No filetype given. Scratchpad cancelled.'
    return
  endif

  let NumberOfScratchPadWindows = 0
  windo let NumberOfScratchPadWindows += s:KilledScratchPad(ftype)
  if NumberOfScratchPadWindows == 0
    call s:OpenScratchPad(ftype, extension)
  endif
endfunction
