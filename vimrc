" == "vim" == {{{
"
"          File:  vimrc
"        Author:  Alvan
"      Modifier:  Alvan
"      Modified:  2017-07-31
"
" --}}}
"
" --------------------------------------------------------------------
" Init
" --------------------------------------------------------------------
set nocompatible

" --------------------------------------------------------------------
" Vars
" --------------------------------------------------------------------
if !exists('$VIMDIR')
    let $VIMDIR = has('unix') ? $HOME . "/.vim" : $VIM . "/vimfiles"
en

if !exists('$VIMDOT')
    let $VIMDOT = has('unix') ? '.' : '_'
en

" --------------------------------------------------------------------
" Func
" --------------------------------------------------------------------
func! GotoExitPos()
    if line("'\"") > 1 && line("'\"") <= line("$")
        exe "normal! g`\""
    en
endf
au BufReadPost * call GotoExitPos()

func! ExecUserLcd()
    silent! lcd %:p:h
endf
au BufEnter * call ExecUserLcd()

func! QuitIfNoWin()
    let n = winnr('$')
    while n >= 0
        let t = getwinvar(n, '&filetype')
        if t != "nerdtree"
                    \ && t != "minibufexpl"
                    \ && t != "tagbar"
                    \ && t != "qf"
            return
        en

        let n -= 1
    endw

    if tabpagenr('$') == 1
        exe 'qa'
    else
        exe 'tabclose'
    en
endf
au BufEnter,BufDelete,BufWinLeave * call QuitIfNoWin()

func! AutoPairMap(...)
    let map = {
                \'"': '""<left>',
                \"'": "''<left>",
                \'`': '``<left>',
                \'(': '()<left>',
                \'[': '[]<left>',
                \'{<CR>': '{}<ESC>i<CR><ESC>O'
                \}
    for key in keys(map)
        if (a:0 > 0 && a:1 == 1) || mapcheck(key, 'i') == ""
            exe "inoremap " . key . " " . map[key]
        else
            exe "iunmap " . key
        en
    endfor
endf
call AutoPairMap(1)

" --------------------------------------------------------------------
" Mode
" --------------------------------------------------------------------
if has('mouse')
    set mouse=a
en
set clipboard+=unnamed

set noeb
set novb
set vb t_vb=

set confirm

" set gcr=a:block-blinkon0
set nowrap
set guioptions-=l
set guioptions-=r
set guioptions-=L
set guioptions-=R
set guioptions-=T
set guioptions+=m
set guitablabel=[%N]\ %t\ %M

set bsdir=buffer

set history=100
set hid

set enc=utf-8
set fenc=utf-8
set fencs=ucs-bom,utf-8,cp936,gb18030,gbk,gb2312
" set bin

set t_Co=256
set background=dark
let g:colors_name = "solarized"

if has("mac")
    set guifont=Yahei\ Mono:h13
elseif has("unix")
    set guifont=Yahei\ Mono\ 10
else
    set guifont=Yahei\ Mono:h10
en

set laststatus=2
set statusline=\ %F\ %Y\ %{&fileformat}\ %{&fileencoding}\ %{(&bomb?\"[BOM]\":\"\")}\ Row\ \[%l/%L\ %<%P]\ Col\ \[%c%V]\ \ %m\ %r

set wildmenu
set showcmd
set nosmd

set shortmess=atI
set scrolloff=5

" set cc=80
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

set iskeyword+=_,@,%,#
set lbr
set display=lastline

set wildignore+=*.swp,*\\.git\\*,*\\.hg\\*,*\\.svn\\*,*/.git/*,*/.hg/*,*/.svn/*

set formatoptions+=mM
set backspace=indent,eol,start

set ph=15
" set cot=menuone,preview
set cot=menuone
set complete-=k complete+=k

set tags+=tags;

" --------------------------------------------------------------------
" Keys
" --------------------------------------------------------------------
nn <leader>ww :ToggleBufExplorer<CR>
nn <leader>wf :NERDTreeFind<CR>
nn <leader>wh :NERDTreeToggle<CR>
nn <leader>wl :TagbarToggle<CR>
nn <leader>wm :TagbarToggle<CR>:NERDTreeToggle<CR>

nn <leader>sf :Rgrep<CR>

" xn < <gv
" xn > >gv

" :W sudo saves the file
" (useful for handling the permission-denied error)
if has("unix")
    com! W w !sudo tee % > /dev/null
en

" press o to open file in quickfix window
au BufReadPost quickfix nn <buffer> <silent> o <CR>

" --------------------------------------------------------------------
" Conf
" --------------------------------------------------------------------

" Acomment
"
let g:acomment_define = {'php': '// %s'}

" Airline
"
let g:airline_skip_empty_sections = 1
let g:airline_mode_map = {
            \ '__' : ' - ',
            \ 'n'  : '-N-',
            \ 'i'  : 'Ins',
            \ 'R'  : 'Rep',
            \ 'c'  : 'Cmd',
            \ 'v'  : 'Vis',
            \ 'V'  : 'V-L',
            \ '' : 'V-B',
            \ 's'  : 'Sel',
            \ 'S'  : 'S-L',
            \ '' : 'S-B',
            \ }

let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'

let g:airline_symbols = {}
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

let g:airline#extensions#tagbar#enabled = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = g:airline_left_sep
let g:airline#extensions#tabline#left_alt_sep = g:airline_left_alt_sep
let g:airline#extensions#tabline#right_sep = g:airline_right_sep
let g:airline#extensions#tabline#right_alt_sep = g:airline_right_alt_sep
let g:airline#extensions#tabline#buffers_label = 'Bufs'
let g:airline#extensions#tabline#tabs_label = 'Tabs'
let g:airline#extensions#tabline#fnamemod = ':p:t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_nr_format = ' %s: '
let g:airline#extensions#tabline#buffer_nr_show = 1
if g:airline#extensions#tabline#enabled
    nm <TAB> <Plug>AirlineSelectNextTab
    nm <S-TAB> <Plug>AirlineSelectPrevTab
en

" BufExplorer
"
let g:bufExplorerShowTabBuffer = 1
let g:bufExplorerDisableDefaultKeyMapping = 1

" Indexer
"
let g:indexer_root_setting = '_indexer.json'

" Closetag
"
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx"

" CtrlP
"
let g:ctrlp_use_caching = 0
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_match_window = 'order:ttb,max:16,results:30'
let g:ctrlp_custom_ignore = {
            \ 'file': '\.\(pkg\|dmg\|exe\|so\|dll\|pyc\|pdf\|jpg\|jpeg\|png\|gif\|bmp\|gz\|zip\|rar\)$',
            \ }

let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_extensions = ['quickfix', 'mark', 'tag', 'mixed', 'modified']
let g:ctrlp_root_markers = ['root.dir', '.root.dir', '.git', '.hg']
let g:ctrlp_prompt_mappings = {
            \ 'PrtBS()':              ['<bs>'],
            \ 'PrtSelectMove("j")':   ['<tab>', '<c-j>', '<down>'],
            \ 'PrtSelectMove("k")':   ['<s-tab>', '<c-k>', '<up>'],
            \ 'ToggleFocus()':        [''],
            \ 'ToggleRegex()':        ['<c-r>'],
            \ 'PrtExpandDir()':       [''],
            \ }

let g:ctrlp_reuse_window = 'startify'

" Dicts
"
let g:dict_spec = {
            \ 'vim': ['vim'],
            \ 'php': ['php'], '*.phtml': ['php', 'js'],
            \ '*.html': ['js'],
            \ 'javascript': ['js'],
            \ }

" DrawIt
"
let g:DrChipTopLvlMenu = "Tools."

" Grep
"
" The serach term is quoted by single quote,
" so if we need to search single quote, we should close the single quote first,
" and then use double quote to wrap the search term.
" ex:
" 'key' => '"'key'"'
"
"
" let g:Grep_Default_Options = '-I'
let g:Grep_Use_Async = 0
let g:Grep_Skip_Dirs = '.git RCS CVS SCCS'
let g:Grep_Skip_Files = '*~ *,v s.* *.pyc *.swp *.jpg *.png'

" PHP indent
let g:PHP_vintage_case_default_indent = 1

" Markdown
"
let g:vim_markdown_folding_disabled = 1

" MiniBufExpl
"
let g:miniBufExplDebugLevel = 0

" NERDTree
"
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = ['\~$', '\.pyc$', '\.DS_Store']
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeCascadeOpenSingleChildDir = 0

" Solarized
"
let g:solarized_menu = 0
let g:solarized_termtrans = 1

" Startify
"
" let g:startify_disable_at_vimenter = 1
let g:startify_custom_header = []
let g:startify_change_to_dir = 1
let g:startify_bookmarks = [ $VIMDIR . '/vimrc' ]
let g:startify_session_dir = $HOME.'/'.$VIMDOT.'vim_startify_ses'

au User Startified setlocal buftype=
au User Startified nmap <buffer> o <plug>(startify-open-buffers)

" Supertab
"
" let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionType = "<c-n>"

" Syntastic
"
let g:syntastic_error_symbol = "*"
let g:syntastic_warning_symbol = "!"
let g:syntastic_stl_format = '[%E{*:%fe ~%e}%B{, }%W{!:%fw ~%w}]'
let g:syntastic_quiet_messages = { "level": "warnings", "type": "style" }
" let g:syntastic_ignore_files = ['\m\c\.go$']

" Tagbar
"
let g:tagbar_left = 0
let g:tagbar_sort = 0
let g:tagbar_width = 30
let g:tagbar_compact = 1
let g:tagbar_autoclose = 0
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_map_jump = ['<CR>', 'o']
let g:tagbar_map_togglefold = 'za'

" UltiSnips
"
let g:UltiSnipsSnippetDirectories = ["snips", "UltiSnips"]
let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Vdebug
"
if !exists("g:vdebug_options")
    let g:vdebug_options = {}
en
" let g:vdebug_options['server'] = '192.168.56.1'
let g:vdebug_options['server'] = ''
let g:vdebug_options['port'] = 9001
let g:vdebug_options['path_maps'] = {'/data/':$HOME.'/', '/media/sf_':$HOME.'/', '/media/psf/Home/':$HOME.'/'}

" Vim-Go
"
let g:go_bin_path = expand("$GOPATH/bin/")
let g:go_fmt_command = "goimports"

" --------------------------------------------------------------------
" Rtps
" --------------------------------------------------------------------

filetype off                 " required

set rtp+=$VIMDIR/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
source $VIMDIR/bundle.vimrc
call vundle#end()

filetype plugin indent on    " required

syntax on

" --------------------------------------------------------------------
" End of file : vimrc
