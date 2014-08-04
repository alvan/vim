" MIT License. Copyright (c) 2014 Alvan.
" vim: et ts=4 sts=4 sw=4

function! airline#extensions#_#init(ext)
  call airline#parts#define_raw('file', '%F%m')
  call airline#parts#define_raw('linenr', '%{g:airline_symbols.linenr}%{g:airline_symbols.space}%#__accent_bold#%2l/%L%#__restore__#')
endfunction
