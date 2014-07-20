"  == "acomment" == {{{
"
"          File:  _vimrc
"          Path:  ~/.vim
"        Author:  Alvan
"      Modifier:  Alvan
"      Modified:  2014-07-20
"
"  --}}}
"
" --------------------------------------------------------------------
" Init
" --------------------------------------------------------------------
set nocompatible

let g:user = 'Alvan'

if has("unix")
    let $VIMDIR = $HOME."/.vim"
else
    let $VIMDIR = $VIM."/vimfiles"
endif

" --------------------------------------------------------------------
" Func
" --------------------------------------------------------------------
func! QuitIfNoWin()
    let l = winnr('$')
    while l >= 0
        let t = getwinvar(l, '&filetype')
        if t != "tagbar" && t != "minibufexpl" && t != "nerdtree"
            return
        endif

        let l -= 1
    endw

    if tabpagenr("$") == 1
        exec 'qa'
    else
        exec 'tabclose'
    endif
endf

func! CheckSyntax()
    if &filetype=="php"
        let makeold = &makeprg

        if has("unix")
            setlocal makeprg=\"/usr/bin/php5\"\ -l\ -n\ -d\ html_errors=off
        else
            setlocal makeprg=\"D:\Program\ Files\xampp\php\php.exe\"\ -l\ -n\ -d\ html_errors=off
        endif

        setlocal shellpipe=>
        setlocal errorformat=%m\ in\ %f\ on\ line\ %l

        execute "silent make %"

        let error = 0
        let mktip = ""
        for e in getqflist()
            if e["lnum"] > 0
                let error = 1
                let mktip = e["text"] . " on line " . e["lnum"]
                execute "normal " . e["lnum"] . "gg"
                break
            endif
            if mktip == "" && e["text"] != ""
                let mktip = e["text"]
            endif
        endfor

        " if error == 0
            " execute "normal :"
            " execute "cwindow"
            " redraw
            " echo mktip
        " else
            " execute "normal :"
            " execute "bo cwindow"
        " endif

        if error == 0
            execute "normal :"
            execute "cwindow"
            redraw
            echo mktip
        else
            if mktip != ""
                echo mktip
            endif
        endif

        set makeprg=makeold
    endif
endf

" --------------------------------------------------------------------
" Mode
" --------------------------------------------------------------------
if has('mouse')
    set mouse=a
endif
set clipboard+=unnamed

set noeb
set novb
set vb t_vb=

set confirm

" set langmenu=zh_CN.UTF-8
" language messages zh_CN.utf-8
" source $VIMRUNTIME/delmenu.vim
" source $VIMRUNTIME/menu.vim

set nowrap
set guioptions+=b
set guioptions+=m
set guioptions-=T
set guitablabel=[%N]\ %t\ %M

set bsdir=buffer
set autochdir

set history=100
set hid

set enc=utf-8
set fenc=utf-8
set fencs=ucs-bom,utf-8,cp936,gb18030,gbk,gb2312
" set bin

set t_Co=256
set background=dark
if has("unix")
    set guifont=YaHei\ Mono\ 10
else
    set guifont=YaHei\ Mono:h10
endif

set laststatus=2
" :h statusline
set statusline=\ %F\ %Y\ %{&fileformat}\ %{&fileencoding}\ %{(&bomb?\"[BOM]\":\"\")}\ Row：\[%l/%L\ %<%P]\ Col：\[%c%V]\ \ %m\ %r

set wildmenu
set showcmd
set nosmd

set shortmess=atI
set scrolloff=5

set nu!
set cul
" set cuc

set ambiwidth=double
set smartcase

set showmatch
set mat=2

set hls
set incsearch

set expandtab
set autoindent " same level indent
set smartindent " next level indent

set tabstop=4
set shiftwidth=4
set softtabstop=4
" set list
" set listchars=tab:>-,trail:-

set foldmethod=indent   " fold based on indent
set foldnestmax=3       " deepest fold is 3 levels
set nofoldenable        " dont fold by default

set iskeyword+=_,$,@,%,#
set lbr
set display=lastline

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.swp  " Linux/MacOSX
set wildignore+=.git\*,.hg\*,.svn\*,*.swp        " Windows

set formatoptions+=mM
set backspace=indent,eol,start

set ph=15
" set cot=menuone,preview
set cot=menuone
set complete-=k complete+=k

set tags+=tags;

au BufEnter,BufDelete,BufWinLeave * call QuitIfNoWin()

" --------------------------------------------------------------------
" Keys
" --------------------------------------------------------------------
noremap <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
            \set guioptions-=T <Bar>
            \set guioptions+=m <Bar>
            \else <Bar>
            \set guioptions+=T <Bar>
            \set guioptions+=m <Bar>
            \endif<CR>

vnoremap <silent> * y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap <silent> # y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>

nmap <silent> ;m <Esc>:marks abcdefghijklmnopqrstuvwxyz<CR>

inoremap " ""<ESC>i
inoremap ' ''<ESC>i
inoremap ` ``<ESC>i
imap ( ()<ESC>i
imap [ []<ESC>i
imap {<CR> {}<ESC>i<CR><ESC>O

" add ; to the end of line
" inoremap <silent> <C-e>; <Esc>:call setline('.',getline('.').';')<CR>a

" visually select the full path of a local html file or a URL
" and press <C-l> to open it.
vnoremap <silent> <C-l> y:call system('xdg-open '.shellescape(@@=~'^\s*\(http\\|https\\|ftp\\|file\):/'?@@:('http://'.@@)).' &')<CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

nmap <leader>wh :NERDTreeToggle<CR>
nmap <leader>wk :MBEToggle<CR>
nmap <leader>wl :TagbarToggle<CR>
nmap <leader>wm <leader>wl<leader>wh

" --------------------------------------------------------------------
" Plugin Manager
" --------------------------------------------------------------------

filetype off                 " required

" set rtp+=/usr/local/go/misc/vim
set rtp+=$GOROOT/misc/vim

" set the runtime path to include Vundle and initialize
set rtp+=$VIMDIR/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'alvan/assistant.vim'
Plugin 'altercation/vim-colors-solarized'
" Plugin 'scrooloose/nerdtree'
Plugin 'alvan/nerdtree'
Plugin 'techlivezheng/vim-plugin-minibufexpl'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
" Plugin 'bling/vim-bufferline'
Plugin 'vimprj'
Plugin 'indexer.tar.gz'
" Plugin 'cespare/vim-golang'
Plugin 'dgryski/vim-godef'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'majutsushi/tagbar'
Plugin 'kien/ctrlp.vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'alvan/vim-php-manual'

call vundle#end()            " required

filetype plugin indent on    " required

" --------------------------------------------------------------------
" File Type Based Configs
" --------------------------------------------------------------------
" Go
"
let g:gofmt_command = "goimports"
" let g:godef_split=0
let g:godef_same_file_in_same_window=1

au BufWritePre *.go :Fmt
" au FileType go setlocal formatoptions=cqra1 tw=80 ai nofoldenable
au FileType go compiler go
"
" --------------------------------------------------------------------
" PHP
"
au Filetype php setlocal mps-=<:>
au BufNewFile,Bufread *.php setlocal mps-=<:>
au BufNewFile,Bufread *.php,*.phtml setlocal dictionary+=$VIMDIR/lst/php.lst.txt

hi link phpheredoc string

" au BufWritePre *.php :%s/\s\+$//g
" au BufWritePost *.php exec "normal ''"
" au BufNewFile,Bufread *.js,*.php,*.phtml set noendofline binary

" if has("unix")
    " au BufWritePost *.php,*.phtml :!/usr/bin/php5 -ln %
    " au BufWritePost *.php,*.phtml :call CheckSyntax()
" else
    " au BufWritePost *.php,*.phtml :!"D:\Program Files\xampp\php\php.exe" -ln %
    " au BufWritePost *.php,*.phtml :call CheckSyntax()
" endif
au BufWritePost *.php,*.phtml :call CheckSyntax()

" --------------------------------------------------------------------
" XML
"
au BufNewFile,Bufread *.html,*.xhtml,*.phtml,*.shtml source $VIMDIR/scripts/closetag.vim

" --------------------------------------------------------------------
" JS
"
au BufNewFile,Bufread *.js,*.html,*.xhtml,*.phtml,*.shtml setlocal dictionary+=$VIMDIR/lst/js.lst.txt

" --------------------------------------------------------------------
" *
syntax on

if has('gui_running')
    let g:solarized_termcolors = 256
    " let g:solarized_termtrans = 1
    let g:solarized_menu = 0

    colorscheme solarized
else
    colorscheme calmar256
endif

" --------------------------------------------------------------------
" Plugin Configs
" --------------------------------------------------------------------
let g:snips_author = g:user

let g:acommentAutoIndent = 0
let g:acommentStrictMode = 3
function g:acommentSet()
    let g:acomment = {}
    let g:acomment["user"] = g:user

    if has("unix")
        let g:acomment["reUrl"] = [
                    \["/data/develop/include","."],
                    \["/data/develop/apf/master/library","."],
                    \["/data/develop/apf/library","."],
                    \["/data/develop/apf.git/master/library","."],
                    \["/data/develop/apf.git/library","."],
                    \["/data/develop","."],
                    \]
    endif
endf

" let g:miniBufExplorerMoreThanOne = 1
let g:miniBufExplDebugLevel = 0

let g:NERDTreeDirArrows=0
let g:NERDTreeMinimalUI=1
let g:NERDTreeAlwaysShowUpDirLine=1
let g:NERDTreeAutoCenter=1
let NERDTreeIgnore=['\~$', '\.pyc$', ]

let g:ctags_statusline=1
let g:autotagDisabled=1
let g:autotagExcludeSuffixes="tml.xml.text.txt"

let g:tagbar_left = 0
let g:tagbar_sort = 0
let g:tagbar_width = 30
let g:tagbar_compact = 1
let g:tagbar_autoclose = 0
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_map_jump = ['<CR>', 'o']
let g:tagbar_map_togglefold = 'za'
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

let g:js_indent_log = 0

" Enable ShowMarks
let g:showmarks_enable = 1
" Show which marks
let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Ignore help, quickfix, non-modifiable buffers
let g:showmarks_ignore_type = "hqm"
" Hilight lower & upper marks
" let g:showmarks_hlline_lower = 1
" let g:showmarks_hlline_upper = 1

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Supertab
" let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionType = "<c-n>"

" xml.vim
let g:xml_use_xhtml = 1

" Indexer
let g:indexer_tagsDirname = $HOME.'/.vim_indexer_tags'
let g:indexer_indexerListFilename = $VIMDIR.'/indexer.conf'
let g:indexer_changeCurDirIfVimprjFound = 0
" let g:indexer_ctagsJustAppendTagsAtFileSave = 1
" let g:indexer_debugLogLevel = 3
let g:indexer_disableCtagsWarning=1

" ctrlP
" let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:16'
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_map = '?'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_extensions = ['tag', 'mixed']
let g:ctrlp_root_markers = ['root.dir', '.root.dir', '.git', '.hg']
let g:ctrlp_prompt_mappings = {
            \ 'PrtBS()':              ['<bs>'],
            \ 'PrtSelectMove("j")':   ['<tab>', '<c-j>', '<down>'],
            \ 'PrtSelectMove("k")':   ['<s-tab>', '<c-k>', '<up>'],
            \ 'ToggleFocus()':        [],
            \ 'PrtExpandDir()':       [],
            \ }

" Airline
let g:airline_theme= 'lucius'
" let g:airline_theme= 'zenburn'
" let g:airline_theme= 'solarized'
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
            \ '__' : '-',
            \ 'n'  : 'Nor',
            \ 'i'  : 'Ins',
            \ 'R'  : 'Rep',
            \ 'c'  : 'Cmd',
            \ 'v'  : 'Vis',
            \ 'V'  : 'V⋅L',
            \ '' : 'V⋅B',
            \ 's'  : 'Sel',
            \ 'S'  : 'S⋅L',
            \ '' : 'S⋅B',
            \ }

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
let g:airline_symbols.space = "\ua0"

let g:airline#extensions#whitespace#enabled = 0

" Debugger
let g:debuggerPort = 9001
" client: server
let g:debuggerPath = {'sep':['/', '/'], 'map': [
            \[$HOME, '/data/'],
            \]}

" --------------------------------------------------------------------
" End of file : .vimrc