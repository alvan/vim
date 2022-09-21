" --------------------------------------------------------------------
" Init
" --------------------------------------------------------------------
set nocompatible
call has('python3')

" --------------------------------------------------------------------
" Vars
" --------------------------------------------------------------------
if !exists('$VIMDIR')
    let $VIMDIR = has('unix') ? $HOME . "/.vim" : $VIM . "/vimfiles"
endif

if !exists('$VIMDOT')
    let $VIMDOT = has('unix') ? '.' : '_'
endif

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
if has("gui_running")
    set termguicolors
endif
set background=dark
let g:colors_name = "NeoSolarized"

if has("mac")
    set guifont=Consolas-with-Yahei:h13
elseif has("unix")
    set guifont=Consolas-with-Yahei\ 13
else
    set guifont=Consolas-with-Yahei:h13
endif

set laststatus=2
set statusline=\ %F\ %Y\ %{&fileformat}\ %{&fileencoding}\ %{(&bomb?\"[BOM]\":\"\")}\ Row\ \[%l/%L\ %<%P]\ Col\ \[%c%V]\ \ %m\ %r

set wildmenu
set showcmd
set nosmd

set shortmess=atI
set scrolloff=5

set nu!
set cul
" set cuc
" set cc=120

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

" set listchars=
" set listchars+=tab:⋮\\x20
" set listchars+=leadmultispace:⋮\\x20\\x20\\x20
" set list

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
set cot=menuone
set complete-=k complete+=k

set notagbsearch
set tags+=tags;

" :h last-position-jump
func! GotoExitPos()
    if line("'\"") > 1 && line("'\"") <= line("$")
                \ && &ft !~# '\(commit\|rebase\|svn\)'
                \ && &bt !~# '^\(quickfix\|terminal\|nofile\|help|prompt|popup\)$'
        exe 'normal! g`"'
    endif
endfunction
au BufWinEnter * call GotoExitPos()

func! QuitIfNoWin()
    let n = winnr('$')
    while n >= 0
        let t = getwinvar(n, '&filetype')
        if t != "nerdtree"
                    \ && t != "minibufexpl"
                    \ && t != "tagbar"
                    \ && t != "qf"
            return
        endif

        let n -= 1
    endwhile

    if tabpagenr('$') == 1
        exe 'qa'
    else
        exe 'tabclose'
    endif
endfunction
au BufEnter,BufDelete,BufWinLeave * call QuitIfNoWin()

" --------------------------------------------------------------------
" Conf
" --------------------------------------------------------------------

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


" Set this variable only if you have the powerline font:
let g:airline_powerline_fonts = 1

let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.dirty = ''

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#tabs_label = 'Tabs'
let g:airline#extensions#tabline#fnamemod = ':p:t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_nr_format = ' %s: '
let g:airline#extensions#tabline#buffer_nr_show = 1

"  Ale
"
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 0
let g:ale_pattern_options = {'\.go$': {'ale_enabled': 0}}
let g:ale_fix_on_save = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_fixers = {}
let g:ale_fixers.javascript = ['prettier', 'eslint']
let g:ale_fixers.html = ['html-beautify']
let g:ale_fixers.json = ['prettier']
let g:ale_fixers.vue = ['prettier', 'eslint']
let g:ale_fixers.php = ['php_cs_fixer']

" Autoformat
"
let g:autoformat_verbosemode = 0
let g:formatters_vue = ['prettier', 'eslint_local']
let g:run_all_formatters_vue = 1
let g:formatters_javascript = ['prettier', 'eslint_local']
let g:run_all_formatters_javascript = 1

" BufExplorer
"
let g:bufExplorerSortBy = 'number'
let g:bufExplorerShowNoName = 1
let g:bufExplorerShowTabBuffer = 1
let g:bufExplorerDisableDefaultKeyMapping = 1

" Comment
"
let g:comment_format = {'php': '// %s'}

" Indexer
"
let g:indexer_root_setting = 'vim_indexer.json'

" Closetag
"
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.vue,*.tmpl"

" CtrlP
"
let g:ctrlp_reuse_window = 'startify'
let g:ctrlp_open_multiple_files = '1r'
let g:ctrlp_max_files = 100000
let g:ctrlp_max_depth = 100
let g:ctrlp_lazy_update = 100
let g:ctrlp_use_caching = 0
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_match_window = 'order:ttb,max:20,results:20'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules)$',
            \ 'file': '\v\.(swp|pkg|dmg|exe|so|dll|pyc|doc|docx|pdf|jpg|jpeg|png|gif|bmp|tar|gz|zip|rar)$',
            \ }
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_extensions = ['quickfix', 'mark', 'tag', 'mixed', 'modified']
let g:ctrlp_root_markers = ['.project', '.root', 'root.dir', '.root.dir', '.git', '.hg']
let g:ctrlp_prompt_mappings = {
            \ 'PrtBS()':              ['<bs>'],
            \ 'PrtSelectMove("j")':   ['<tab>', '<c-j>', '<down>'],
            \ 'PrtSelectMove("k")':   ['<s-tab>', '<c-k>', '<up>'],
            \ 'ToggleFocus()':        [''],
            \ 'ToggleRegex()':        ['<c-r>'],
            \ 'PrtExpandDir()':       [''],
            \ }

" Dicts
"
let g:dict_spec = {
            \ 'vim': ['vim'],
            \ 'php': ['php'], '*.phtml': ['php', 'js'],
            \ '*.html': ['js'],
            \ 'javascript': ['js'],
            \ }

" FZF
let g:fzf_colors = {
            \ 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment']
            \ }

" LeaderF
"
let g:Lf_HideHelp = 1
let g:Lf_WindowHeight = 0.4
let g:Lf_ShowDevIcons = 0
let g:Lf_StlColorscheme = 'default'
let g:Lf_PopupColorscheme = 'gruvbox_default'
if exists('g:colors_name') && stridx(tolower(g:colors_name), 'solarized') >= 0
    let g:Lf_StlPalette = {
                \   'stlName': {
                \       'guifg': '#fdf6e3',
                \       'guibg': '#839496',
                \       'ctermfg': '15',
                \       'ctermbg': '12',
                \   },
                \   'stlCategory': {
                \       'guifg': '#eee8d5',
                \       'guibg': '#586e75',
                \       'ctermfg': '7',
                \       'ctermbg': '10',
                \   },
                \   'stlNameOnlyMode': {
                \       'guifg': '#eee8d5',
                \       'guibg': '#2aa198',
                \       'ctermfg': '8',
                \       'ctermbg': '6',
                \   },
                \   'stlFullPathMode': {
                \       'guifg': '#eee8d5',
                \       'guibg': '#b58900',
                \       'ctermfg': '7',
                \       'ctermbg': '3',
                \   },
                \   'stlFuzzyMode': {
                \       'guifg': '#002b36',
                \       'guibg': '#b58900',
                \       'ctermfg': '8',
                \       'ctermbg': '3',
                \   },
                \   'stlRegexMode': {
                \       'guifg': '#073642',
                \       'guibg': '#268bd2',
                \       'ctermfg': '0',
                \       'ctermbg': '4',
                \   },
                \   'stlCwd': {
                \       'guifg': '#fdf6e3',
                \       'guibg': '#586e75',
                \       'ctermfg': '15',
                \       'ctermbg': '10',
                \   },
                \   'stlBlank': {
                \       'guifg': 'NONE',
                \       'guibg': '#073642',
                \       'ctermfg': 'NONE',
                \       'ctermbg': '0',
                \   },
                \   'stlLineInfo': {
                \       'guifg': '#fdf6e3',
                \       'guibg': '#586e75',
                \       'ctermfg': '15',
                \       'ctermbg': '10',
                \   },
                \   'stlTotal': {
                \       'guifg': '#fdf6e3',
                \       'guibg': '#839496',
                \       'ctermfg': '15',
                \       'ctermbg': '12',
                \   }
                \ }

    if &background == 'light'
        let g:Lf_StlPalette.stlBlank = {
                    \     'guifg': 'NONE',
                    \     'guibg': '#eee8d5',
                    \     'ctermfg': 'NONE',
                    \     'ctermbg': '7',
                    \ }
    endif
endif

let g:Lf_NormalMap = {
            \ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
            \ "Colorscheme": [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']]
            \ }
let g:Lf_PreviewResult = {
            \ 'File': 0,
            \ 'Colorscheme': 1
            \}
let g:Lf_PreviewInPopup = 1
let g:Lf_WorkingDirectoryMode = 'AF'
let g:Lf_RootMarkers = ['.git', '.svn', '.hg', '.project', '.root', 'root.dir', '.root.dir']
let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]','*.ico','*.jpeg','*.jpg','*.png','*.gif','*.psd']
            \}
let g:Lf_DefaultExternalTool = 'rg'
let g:Lf_UseVersionControlTool = 0

" LeaderG
"
let g:leaderg_default_mode = 'dirs'

" PHP indent
"
let g:PHP_vintage_case_default_indent = 1

" Markdown
"
let g:vim_markdown_folding_disabled = 1

" NERDTree
"
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinSize = 36
let g:NERDTreeIgnore = ['\~$', '\.pyc$', '\.DS_Store']
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeCascadeOpenSingleChildDir = 0

" Solarized
"
let g:solarized_menu = 0
let g:solarized_termtrans = 1

" NeoSolarized
"
let g:neosolarized_vertSplitBgTrans = 0
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 1

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
let g:tagbar_width = 32
let g:tagbar_compact = 1
let g:tagbar_autoclose = 0
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_map_jump = ['<CR>', 'o']
let g:tagbar_map_togglefold = 'za'
let g:tagbar_autoclose_netrw = 0

" UltiSnips
"
if has('python')
    let g:UltiSnipsUsePythonVersion = 2
endif
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsSnippetDirectories = ["snips", "UltiSnips"]

" Vdebug
"
if !exists("g:vdebug_options")
    let g:vdebug_options = {}
endif
" let g:vdebug_options['server'] = '192.168.56.1'
let g:vdebug_options['server'] = ''
let g:vdebug_options['port'] = 9001
let g:vdebug_options['path_maps'] = {'/data/':$HOME.'/', '/media/sf_':$HOME.'/'}

" Vim-Go
"

" --------------------------------------------------------------------
" Keys
" --------------------------------------------------------------------

" :W sudo saves the file
" (useful for handling the permission-denied error)
if has("unix")
    com! W w !sudo tee % > /dev/null
endif

" Press o to open file in quickfix window
au BufReadPost quickfix nn <buffer> <silent> o <CR>

" Use <leader>p to format file
if exists('g:autoformat_verbosemode')
    nn <leader>p :Autoformat<CR>
endif

" Shortcut keys for searching
vn <silent> * y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
vn <silent> # y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>

" Window management
nn <leader>ww :ToggleBufExplorer<CR>
nn <leader>wf :NERDTreeFind<CR>
nn <leader>wh :NERDTreeToggle<CR>
nn <leader>wl :TagbarToggle<CR>
nn <leader>wm :TagbarToggle<CR>:NERDTreeToggle<CR>

" Set the current directory
nn <leader>cd :lcd <C-R>=expand('%:p:h')<CR>

" Automatically insert pairs of characters
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
        endif
    endfor
endfunction
call AutoPairMap(1)

" Use <Tab> and <S-TAB> to switch tabs easily~
if exists('g:airline#extensions#tabline#enabled')
            \ && g:airline#extensions#tabline#enabled
    nm <TAB> <Plug>AirlineSelectNextTab
    nm <S-TAB> <Plug>AirlineSelectPrevTab
endif

" --------------------------------------------------------------------
" Plug
" --------------------------------------------------------------------

filetype off                 " required

call plug#begin()
source $VIMDIR/plugs.vimrc
call plug#end()

filetype plugin indent on    " required
syntax on

" --------------------------------------------------------------------
" End of file : vimrc
