if exists('b:did_local_ftplugin')
    finish
endif
let b:did_local_ftplugin = 1

hi link phpheredoc string

" add ; to the end of line
" inoremap <silent> <buffer> <C-e> <Esc>:call setline('.',getline('.').';')<CR>a

inoremap <buffer> <leader>pd <ESC>:call PhpDocSingle()<CR>i
nnoremap <buffer> <leader>pd :call PhpDocSingle()<CR>
vnoremap <buffer> <leader>pd :call PhpDocRange()<CR>
