*Vim-ScratchPad*
================

This plug-in adds a key binding, by default `dsp` (= `Display Scratch Pad`), that toggles a scratchpad.
By default, it assumes the filetype `FT` and working directory `CWD` of the currently active buffer, and is stored in `CWD/.scratchpads/scratchpad.FT`.

The directory where the scratchpad is stored in is set by the variable
```vim
    let g:scratchpad_path = '.scratchpads'
```
It may be an absolute or relative path.
If it is a relative path (such as, by default `.scratchpads`), then it is relative to the working directory of the currently active window.

The filetype of the scratchpad is set by the variable
```vim
    let g:scratchpad_ftype = ''
```
If it is empty (as by default), then the filetype is that of the currently active buffer.

The key binding is set by the mapping
```vim
    nmap dsp <Plug>(ToggleScratchPad)
```
