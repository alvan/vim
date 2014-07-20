" MIT License. Copyright (c) 2014 Alvan.
" vim: et ts=4 sts=4 sw=4

if !exists(':MBEToggle')
    finish
endif

let s:ft = 'minibufexpl'
let s:nm = 'BufExplorer'

" Define an init function that will be invoked from extensions.vim
function! airline#extensions#minibufexpl#init(ext)
    " Add a funcref so that we can run some code prior to the
    " statusline getting modifed.
    call a:ext.add_statusline_func('airline#extensions#minibufexpl#apply')
    call a:ext.add_inactive_statusline_func('airline#extensions#minibufexpl#leave')
endfunction

function! airline#extensions#minibufexpl#apply(...)
    " Check for the filetype.
    if getwinvar(a:2.winnr, '&filetype') == s:ft
        call a:1.add_section_spaced('airline_a', s:nm)
        call a:1.add_section('airline_b', '')
        " call a:1.add_section_spaced('airline_c', '')

        return 1
    endif
endfunction

function! airline#extensions#minibufexpl#leave(...)
    " Check for the filetype.
    if getwinvar(a:2.winnr, '&filetype') == s:ft
        call a:1.add_section_spaced('airline_a', s:nm)
        " active buffer?
        "
        " call a:1.add_section('airline_b', '')
        " call a:1.add_section_spaced('airline_c', '%{expand("#".expand("<cfile>").":p")}')

        return 1
    endif
endfunction
