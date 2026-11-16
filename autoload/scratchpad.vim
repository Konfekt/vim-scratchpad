" slash adapted to the OS
let s:slash = exists('+shellslash') && !&shellslash ? '\' : '/'

" g:scratchpad_path with a leading ~ expanded and trailing slashes removed.
function! scratchpad#Path() abort
  let path = g:scratchpad_path
  if path =~# '^\~\%([\\/]\|$\)'
    let path = fnamemodify(path, ':p')
  endif
  return substitute(path, '.\zs[\\/]\+$', '', '')
endfunction

function! scratchpad#IsAbsolute(path) abort
  return a:path =~# '^\%([\\/]\|\a:[\\/]\)'
endfunction

function! s:SplitWindow() abort
  return winheight(0) * 5 > winwidth(0) * 2 ? 'aboveleft' : 'topleft vertical'
endfunction

function! s:OpenScratchPad(ftype, extension) abort
  let cwd = getcwd()
  let path = scratchpad#Path()
  let scratchpad_dir = scratchpad#IsAbsolute(path) ? path : cwd .. s:slash .. path
  let scratchpad_path = scratchpad_dir .. s:slash .. 'scratchpad.' .. a:extension
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
    " Scratch buffer is already created. Jump to the window displaying it,
    " or open it in a new one.
    let scr_winid = bufwinid(scr_bufnum)
    if scr_winid != -1
      call win_gotoid(scr_winid)
    else
      exe s:SplitWindow() 'split +buffer' .. scr_bufnum
    endif
  endif
endfunction

" Whether buffer {bufnr} is a scratchpad of filetype {ftype}.
function! s:IsScratchPad(bufnr, ftype) abort
  let path = scratchpad#Path()
  let pattern = '\V' .. (scratchpad#IsAbsolute(path) ? '\^' : '\[\\/]') ..
        \ escape(path, '\') .. '\[\\/]scratchpad.\f\+\$'
  return fnamemodify(bufname(a:bufnr), ':p') =~? pattern
        \ && getbufvar(a:bufnr, '&filetype') ==? a:ftype
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

  " Close all visible scratchpads of this filetype, saving them first;
  " open one if there were none.
  let scratchpads = filter(uniq(sort(tabpagebuflist(), 'n')), 's:IsScratchPad(v:val, ftype)')
  for bufnr in scratchpads
    call win_execute(bufwinid(bufnr), 'update')
    execute 'bdelete' bufnr
  endfor
  if empty(scratchpads)
    call s:OpenScratchPad(ftype, extension)
  endif
endfunction
