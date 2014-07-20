" MIT License. Copyright (c) 2014 Alvan.
" vim: et ts=4 sts=4 sw=4

if !exists(':NERDTreeToggle')
    finish
endif

let s:ft = 'nerdtree'
let s:nm = 'SysExplorer'

" Define an init function that will be invoked from extensions.vim
function! airline#extensions#nerdtree#init(ext)
    " Add a funcref so that we can run some code prior to the
    " statusline getting modifed.
    call a:ext.add_statusline_func('airline#extensions#nerdtree#apply')
    call a:ext.add_inactive_statusline_func('airline#extensions#nerdtree#leave')
endfunction

function! airline#extensions#nerdtree#apply(...)
    " Check for the filetype.
    if getwinvar(a:2.winnr, '&filetype') == s:ft
        call a:1.add_section_spaced('airline_a', s:nm)
        call a:1.add_section('airline_b', '%<%{getcwd()}')

        return 1
    endif
endfunction

function! airline#extensions#nerdtree#leave(...)
    " Check for the filetype.
    if getwinvar(a:2.winnr, '&filetype') == s:ft
        call a:1.add_section_spaced('airline_a', s:nm)

        return 1
    endif
endfunction
