setlocal bin

inoremap <buffer> <leader>pd <ESC>:call PhpDocSingle()<CR>i
nnoremap <buffer> <leader>pd :call PhpDocSingle()<CR>
vnoremap <buffer> <leader>pd :call PhpDocRange()<CR>
