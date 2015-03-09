if exists('b:did_local_ftplugin')
    finish
endif
let b:did_local_ftplugin = 1

setlocal bin
setlocal noet

" SuperTab
if exists('*SuperTabSetDefaultCompletionType')
    call SuperTabSetDefaultCompletionType("<c-x><c-o>")
endif
