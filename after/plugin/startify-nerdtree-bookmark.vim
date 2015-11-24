" == "acomment" == {{{
"
"          File:  startify-nerdtree-bookmark.vim
"        Author:  Alvan
"      Modifier:  Alvan
"      Modified:  2015-11-24
"
" --}}}
"
if exists("g:loaded_startify_nerdtree_bookmark")
    finish
endif
let g:loaded_startify_nerdtree_bookmark = "0.1"

let g:debugs = []
if exists("g:NERDTreeBookmarksFile")
    if filereadable(g:NERDTreeBookmarksFile)
        if !exists("g:startify_bookmarks")
            let g:startify_bookmarks = []
        endif
        for line in readfile(g:NERDTreeBookmarksFile)
            if line != ''
                let path = expand(substitute(line, '^.\{-} \(.*\)$', '\1', ''))

                if filereadable(path)
                    call add(g:startify_bookmarks, path)
                endif
            endif
        endfor
    endif
endif
