" slash adapted to the OS
let s:slash = exists('+shellslash') && !&shellslash ? '\' : '/'

" g:scratchpad_path with a leading ~ expanded and trailing slashes removed.
function! s:Path() abort
  let path = g:scratchpad_path
  if path =~# '^\~\%([\\/]\|$\)'
    let path = fnamemodify(path, ':p')
  endif
  return substitute(path, '.\zs[\\/]\+$', '', '')
endfunction

function! s:IsAbsolute(path) abort
  return a:path =~# '^\%([\\/]\|\a:[\\/]\)'
endfunction

function! s:SplitWindow() abort
  return winheight(0) * 5 > winwidth(0) * 2 ? 'aboveleft' : 'topleft vertical'
endfunction

" Number of the buffer named {path}, or -1. Unlike bufnr({path}), this never
" matches a buffer whose name merely contains {path}.
function! s:BufNr(path) abort
  let path = fnamemodify(a:path, ':p')
  for buf in getbufinfo()
    if buf.name ==# path
      return buf.bufnr
    endif
  endfor
  return -1
endfunction

function! s:OpenScratchPad(ftype, extension) abort
  let cwd = getcwd()
  let path = s:Path()
  let scratchpad_dir = s:IsAbsolute(path) ? path : cwd .. s:slash .. path
  let scratchpad_path = scratchpad_dir .. s:slash .. 'scratchpad.' .. a:extension
  let scr_bufnum = s:BufNr(scratchpad_path)

  " Jump to the window displaying the scratchpad, or open it in a new one.
  if scr_bufnum != -1 && bufwinid(scr_bufnum) != -1
    call win_gotoid(bufwinid(scr_bufnum))
  else
    if scr_bufnum == -1
      if !isdirectory(scratchpad_dir)
        call mkdir(scratchpad_dir, 'p')
      endif
      exe s:SplitWindow() 'new' fnameescape(scratchpad_path)
    else
      exe s:SplitWindow() 'split +buffer' .. scr_bufnum
    endif
    exe 'lchdir' fnameescape(cwd)
  endif

  " :bdelete clears the filetype and buffer-local mappings, so (re)set them
  " each time; the extension alone may not imply the filetype.
  if &l:filetype !=# a:ftype
    let &l:filetype = a:ftype
  endif
  nnoremap <silent><buffer> <Plug>(ToggleScratchPad) :<C-U>update<bar>bdelete<CR>
endfunction

" Whether buffer {bufnr} is a scratchpad of filetype {ftype}.
function! s:IsScratchPad(bufnr, ftype) abort
  let path = s:Path()
  let pattern = '\V' .. (s:IsAbsolute(path) ? '\^' : '\[\\/]') ..
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
