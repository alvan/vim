" MIT License. Copyright (c) 2014 Alvan.
" vim: et ts=4 sts=4 sw=4

function! airline#extensions#_#init(ext)
    call airline#parts#define_raw('file', '%F%m')
endfunction
