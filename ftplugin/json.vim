if exists('b:did_local_ftplugin')
    finish
endif
let b:did_local_ftplugin = 1

nnoremap <buffer> <leader>js :%!python -m json.tool<CR>
