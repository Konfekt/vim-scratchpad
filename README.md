*Vim-ScratchPad*
============

This Vim plug-in adds a key binding, by default `dsp` (= `Display Scratch Pad`), that toggles
a scratchpad. It assumes the file type `FT` and working directory `CWD` of the
currently opened buffer, and is stored in `CWD/.scratchpads/scratchpad.FT`

The subdirectory where the scratchpad is stored in is set by the variable
```vim
    let g:scratchpad_path = '.scratchpads'
```
and the key binding is set by the mapping
```vim
    nmap dsp <Plug>(ToggleScratchPad)
```

