
" Press o to open file in quickfix window
nn <buffer> <silent> o <CR>

if exists('g:qfpreview')
    " Press p to preview file in quickfix window
    nn <buffer> p <plug>(qf-preview-open)
endif
