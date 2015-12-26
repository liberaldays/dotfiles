" First setings"{{{
set t_Co=256
set tags=tags
" let Tlist_Ctags_Cmd = "/opt/local/bin/ctags"  " ctagsのコマンド
set modeline
set number
set numberwidth=5
set ruler
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set showtabline=2
set autoindent
set noerrorbells
set laststatus=2
set history=50
set foldmethod=marker
set noswapfile
set nobackup
set wildmenu
set wildmode=list,longest:full
syntax on
set gfn=Bitstream\ Vera\ Sans\ Mono\ 12
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
set encoding=utf-8
set nocompatible
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" set clipboard += unnamed
" autocmd BufWritePre * :%s/\s\+$//e
autocmd InsertLeave * set nopaste
" 検索を very magic で行う
" nnoremap /  /\v
" set cursorline
" highlight cursorline ctermbg=Blue
" highlight cursorline ctermfg=White
" set cursorcolumn
" highlight CursorColumn ctermbg=Blue
" highlight CursorColumn ctermfg=Green

" filetype off
" filetype plugin indent off
filetype plugin indent on
"
" XXX Undo Tree
if has('persistent_undo')
    set undodir=./.vimundo,~/.vimundo
    set undofile
endif

if has('multi_byte_ime')
  highlight Cursor guifg=#000d18 guibg=#8faf9f gui=bold
  highlight CursorIM guifg=NONE guibg=#ecbcbc
endif

" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

" User Information
let g:username = 'haconeco'
let g:email = 'admin@haccat.com'
"}}}

" Difficult Settings"{{{
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set showcmd  " display incomplete commands
set incsearch " do incremental searching

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

  augroup END
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
end

au BufRead,BufNewFile *.pde set filetype=processing
au BufRead,BufNewFile *.ino set filetype=arduino
au BufRead,BufNewFile *.md set filetype=rmd
au BufRead,BufNewFile *.rmd set filetype=rmd
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
"}}}

" Scouter"{{{
function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
command! -bar -bang -nargs=? -complete=file GScouter
\        echo Scouter(empty(<q-args>) ? $MYGVIMRC : expand(<q-args>), <bang>0)

" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
"}}}

" KEY BIND "{{{
inoremap <C-L> <Right>

noremap ; :
noremap : ;
noremap j gj
noremap k gk
inoremap <C-f> <ESC>
cnoremap <C-f> <ESC>
lnoremap <C-f> <ESC>
noremap <silent> <Esc><Esc> :nohlsearch<CR>

" Open vimrc
nnoremap <silent> <Space>. :<C-u>tabedit ~/dotfiles/_vimrc<CR>:<C-u>lcd %:p:h<CR>
nnoremap <silent> <Space>s. :<C-u>source $MYVIMRC<CR>

noremap tL :<C-u>TagbarToggle<CR>
noremap tn :<C-u>tabnext<CR>
noremap tp :<C-u>tabprevious<CR>
noremap tf :<C-u>tabfirst<CR>
noremap tl :<C-u>tablast<CR>
noremap tN :<C-u>tabnew<CR>
noremap <C-N> :VimFiler<CR>
noremap md :<C-u>lcd %:p:h<CR>

"----------------------------------------------------
"" 引用符等の設定
"----------------------------------------------------
"" カッコやクオートなどを入力した際に左に自動で移動します
" FIXME: set mapping according to filetype
inoremap {} {}<Esc>i
inoremap [] []<Esc>i
inoremap () ()<Esc>i
inoremap "" ""<Esc>i
inoremap '' ''<Esc>i
inoremap <> <><Esc>i

vnoremap {} di{<Esc>pa}<Esc>
vnoremap [] di[<Esc>pa]<Esc>
vnoremap () di(<Esc>pa)<Esc>
vnoremap "" di"<Esc>pa"<Esc>
vnoremap '' di'<Esc>pa'<Esc>
vnoremap <> di<<Esc>pa><Esc>

" Gundo Toggle ==UndoTree==
nnoremap tu :GundoToggle<CR>

" Markmon open
noremap <silent> gm :!markmon % --command "pandoc --mathjax -N -t HTML5" --view "open \"http://localhost:3000\""&<CR>
"}}}

" NeoBundle"{{{
filetype off
 if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle.vim/
   call neobundle#begin(expand('~/.vim/bundle/'))
 endif

 " NeoBundle本体
 NeoBundleFetch 'Shougo/neobundle.vim'
 " 利用中のプラグインをNeoBundle
 NeoBundle 'ervandew/screen'
 " For NeoComplete or NeoComplcache
function! s:meet_neocomplete_requirements()
  return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction
if s:meet_neocomplete_requirements()
    NeoBundle 'Shougo/neocomplete.vim'
    NeoBundleFetch 'Shougo/neocomplcache.vim'
else
    NeoBundleFetch 'Shougo/neocomplete.vim'
    NeoBundle 'Shougo/neocomplcache.vim'
endif
 " NeoBundle 'honza/vim-snippets'
 NeoBundleLazy 'Shougo/neosnippet', {
       \ 'depends': ["Shougo/neosnippet-snippets","Shougo/context_filetype.vim"],
       \ "autoload": {
       \    "insert": 1,
       \ }}
 " Unite 周り
 NeoBundle 'Shougo/unite.vim'
 NeoBundle 'Shougo/neomru.vim'
 NeoBundle 'Shougo/neoyank.vim'
 NeoBundle 'zhaocai/unite-scriptnames'
 NeoBundle 'Shougo/unite-outline'
 NeoBundle 'tsukkee/unite-tag'
 NeoBundle 'osyo-manga/unite-fold'
 NeoBundle 'Shougo/unite-help'
 NeoBundle 'choplin/unite-spotlight'
 NeoBundle 'kannokanno/unite-todo'
 NeoBundleLazy 'yomi322/unite-tweetvim' " unite source for tweetvim
 NeoBundle 'ujihisa/unite-colorscheme'
 NeoBundle 'kana/vim-vspec'
 NeoBundle 'basyura/TweetVim' " twitter client for vim
 NeoBundleLazy 'mattn/webapi-vim'
 NeoBundleLazy 'basyura/twibill.vim'
 NeoBundleLazy 'basyura/bitly.vim'
 NeoBundleLazy 'osyo-manga/TweetVim-powerline-theme'
 NeoBundle 'Shougo/vimshell'
 NeoBundleLazy "Shougo/vimfiler", {
       \ "depends": ["Shougo/unite.vim"],
       \ "autoload": {
       \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
       \   "mappings": ['<Plug>(vimfiler_switch)'],
       \   "explorer": 1,
       \ }}
 NeoBundle 'sjl/gundo.vim'
 NeoBundle 'Rip-Rip/clang_complete'
 NeoBundle 'Shougo/vimproc.vim', { 'build' : {
       \  'cygwin' : 'make -f make_cygwin.mak',
       \  'mac'  : 'make -f make_mac.mak',
       \  'unix' : 'make -f make_unix.mak',
       \   },
       \ }
 NeoBundle 'altercation/vim-colors-solarized'
 NeoBundle 'tomasr/molokai'
 NeoBundle 'tyru/restart.vim'
 " NeoBundle 'tyru/caw.vim'
 NeoBundle 'thinca/vim-quickrun'
 " Python 周り
 NeoBundleLazy 'lambdalisue/vim-django-support'
 NeoBundle 'reinh/vim-makegreen'
 NeoBundle 'lambdalisue/nose.vim'
 NeoBundleLazy 'alfredodeza/pytest.vim', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ }}
"  NeoBundle 'sontek/rope-vim'
 NeoBundleLazy "davidhalter/jedi-vim", {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ },
       \ "build": {
       \   "mac": "pip install jedi",
       \   "unix": "pip install jedi",
       \ }}
 ", { 'rev' : '211cbf1fb7'}
 NeoBundleLazy 'jmcantrell/vim-virtualenv', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ }}
 NeoBundle 'benmills/vimux'
 " NeoBundle 'ivanov/vim-ipython'
 NeoBundleLazy 'nvie/vim-flake8', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ }}
 NeoBundleLazy 'mitechie/pyflakes-pathogen', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ }}
 NeoBundleLazy 'tell-k/vim-autopep8', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ },
       \ "build": {
       \   "mac": "pip install jedi",
       \   "unix": "pip install jedi",
       \ }}
 NeoBundleLazy 'hdima/python-syntax', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ }}
 " NeoBundle 'nathanaelkane/vim-indent-guides'
 NeoBundleLazy 'Yggdroot/indentLine', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ }}
 NeoBundleLazy 'hynek/vim-python-pep8-indent', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ }}
 NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
       \ "autoload": {
       \   "filetypes": ['javescript'],
       \ }}
 NeoBundleLazy 'jelera/vim-javascript-syntax', {
       \ "autoload": {
       \   "filetypes": ['javescript'],
       \ }}
 NeoBundle 'marijnh/tern_for_vim', {
       \ "autoload": {
       \   "filetypes": ['javescript'],
       \ },
       \ 'build': {
       \   'others': 'npm install'
       \}}
 NeoBundle 'myhere/vim-nodejs-complete', {
       \ "autoload": {
       \   "filetypes": ['javescript'],
       \ }}
 NeoBundle 'thinca/vim-ref'
 " NeoBundle 'TwitVim'
 NeoBundle 'jalvesaq/R-Vim-runtime'
 NeoBundle 'jcfaria/Vim-R-plugin'
 " NeoBundle 'vim-scripts/Vim-R-plugin'
 NeoBundle 'itchyny/lightline.vim'
 NeoBundle 'majutsushi/tagbar'
 NeoBundleLazy 'sophacles/vim-processing', {
       \ "autoload": {
       \  "filetypes": ["processing"],
       \ }}
 NeoBundleLazy 'vim-latex/vim-latex', {
       \ "autoload": {
       \   "filetypes": ["tex"],
       \ }}
 NeoBundle 'vim-scripts/R-syntax-highlighting'
 NeoBundle 'LeafCage/foldCC'
 NeoBundle 'tpope/vim-fugitive'
 NeoBundle 'xolox/vim-reload'
 NeoBundle 'xolox/vim-misc'
 NeoBundle 'pentie/VimRepress'
 NeoBundle 'tpope/vim-markdown'
 NeoBundleLazy 'jszakmeister/markdown2ctags', {
       \ "autoload": {
       \   "filetypes": ["rmd","markdown"],
       \ }}
 NeoBundle 'kannokanno/previm'
 NeoBundle 'tyru/open-browser.vim'
 " Editing Text 3 Gods Arms
 NeoBundle 'tpope/vim-surround'
 NeoBundle 'vim-scripts/Align'
 " NeoBundle 'vim-scripts/YankRing.vim'
 NeoBundle 'aperezdc/vim-template'
 NeoBundle 'xolox/vim-session', {
       \ 'depends' : 'xolox/vim-misc',
       \ }
 NeoBundle 'deton/jasegment.vim'
 NeoBundle 'rizzatti/dash.vim'
 NeoBundle 'osyo-manga/vim-precious'
 NeoBundle 'elzr/vim-json'
 NeoBundleLazy '5t111111/neat-json.vim', {
       \ "autoload": {
       \   "filetypes": ["json"],
       \ },
       \ 'depends' : 'elzr/vim-json',
       \ }
 NeoBundleLazy 'scrooloose/syntastic', {
       \ "autoload": {
       \   "filetypes": ["c","r","php","go","ruby", "python"],
       \ }}
 NeoBundle 'haya14busa/incsearch.vim', {
       \ 'depends' : 'osyo-manga/vital-over',
       \ }
 NeoBundle 'haya14busa/incsearch-fuzzy.vim', {
       \ 'depends' : 'haya14busa/incsearch.vim',
       \ }
 NeoBundle 'haya14busa/vim-migemo', " {
 "      \ "build": {
 "      \   "mac": "brew install cmigemo",
 "      \   "unix": "pip install jedi",
 "      \ }}
 NeoBundle 'haya14busa/incsearch-migemo.vim', {
       \ 'depends' : 'haya14busa/incsearch.vim',
       \ }
 NeoBundle 'haya14busa/incsearch-easymotion.vim', {
       \ 'depends' : ['Shougo/unite.vim', 'haya14busa/incsearch.vim' ],
       \ }
 NeoBundle 'easymotion/vim-easymotion'
 NeoBundle 'ujihisa/neco-look'
 NeoBundle 'kien/rainbow_parentheses.vim'
 " NeoBundle 'tyru/skk.vim'
 call neobundle#end()
 filetype plugin indent on
 NeoBundleCheck
 "}}}

" Settings of VimShell"{{{
" \is: シェルを起動
 nnoremap <silent> \is :VimShell<CR>
 nnoremap <silent> \isp :VimShellPop<CR>
 " \ipy: ipythonを非同期で起動
 nnoremap <silent> \ip :VimShellInteractive ipython-2.7 console<CR>
" \irb: irbを非同期で起動
 nnoremap <silent> \irb :VimShellInteractive irb<CR>
" \irr: Rを非同期で起動
 nnoremap <silent> \irr :VimShellInteractive r<CR>
 " 選択中に\ss: 非同期で開いたインタプリタに選択行を評価させる
 vnoremap \ss :VimShellSendString<CR>
 " \ss: 非同期で開いたインタプリタに現在の行を評価させる
 nnoremap <silent> \ss <S-v>:VimShellSendString<CR>"}}}

 " VimFiler Settings"{{{
nnoremap <Leader>e :VimFilerExplorer<CR>
" close vimfiler automatically when there are only vimfiler open
autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
let s:hooks = neobundle#get_hooks("vimfiler")
function! s:hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
endfunction
unlet s:hooks
" Edit file by tabedit.
let g:vimfiler_edit_action = 'tabopen'
" Like Textmate icons.
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'
"}}}

" quickrun.vim{{{
let g:quickrun_config = {
            \ 'tex' : {
            \   'command' : 'latexmk',
            \   'outputter' : 'error',
            \   'cmdopt' : '-gg',
            \   'outputter/error/error' : 'quickfix',
            \   'exec': ['%c %o']
            \ },
            \ 'tex/lualatex' : {
            \   'command' : 'latexmk',
            \   'cmdopt' : '-gg -pdf',
            \   'outputter' : 'error',
            \   'outputter/error/error' : 'quickfix',
            \   'exec': ['%c %o %s']
            \ },
            \ 'sh' : {
            \   'outputter' : 'multi:buffer:quickfix',
            \ },
            \ 'r' : {
            \   'command' : 'Rscript',
            \ },
            \ 'markdown' : {
            \   'outputter' : 'browser',
            \   'command': 'pandoc',
            \   'cmdopt' : '--mathjax -N',
            \   'exec': '%c %o --from=markdown --to=HTML5 %s %a',
            \ },
            \ 'python' : {
            \   'command' : 'python2.7',
            \ },
            \ 'processing' : {
            \     'command': 'processing-java',
            \     'exec': '%c --sketch=%s:p:h/ --output=/tmp/processing --run --force'
            \  }}
let g:quickrun_config['_'] = {
            \   'runner' : 'vimproc',
            \   'runner/vimproc/updatetime' : 100,
            \}
" let g:quickrun_config.tex = {
"       \  "command" : "texTopdf",
"       \  "outputter" : "error:quickfix",
"       \  "runner" : "vimproc",
"       \}
nmap <Leader>r <Plug>(quickrun)
nmap <expr><Leader>lr quickrun#run('tex/lualatex')
set splitright
"}}}

" NEOCOMPLETE"{{{
if s:meet_neocomplete_requirements()
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
  let g:neocomplete#enable_auto_close_preview = 1
  " disable preview pane
  set completeopt-=preview

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplete#undo_completion()
  " inoremap <expr><C-l>     neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#smart_close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h>  neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>   neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

  " For cursor moving in insert mode(Not recommended)
  " inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
  " inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
  " inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
  " inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"

  " " Or set this.
  " let g:neocomplete#enable_cursor_hold_i = 1
  " " Or set this.
  " let g:neocomplete#enable_insert_char_pre = 1

  " " AutoComplPop like behavior.
  " let g:neocomplete#enable_auto_select = 1
  " " Shell like behavior(not recommended).
  " set completeopt+=longest
  " let g:neocomplete#enable_auto_select = 1
  " let g:neocomplete#disable_auto_complete = 1
  " inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  "autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  " Python - jedi
  autocmd FileType python setlocal omnifunc=jedi#completions
  "let g:jedi#popup_select_first=0
  let g:jedi#completions_enabled = 0
  let g:jedi#auto_vim_configuration = 0

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif

  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif

  if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
  endif

  " Python - jedi
  let g:neocomplete#force_omni_input_patterns.python =
        \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
  let g:neocomplete#sources#omni#input_patterns.php =
        \ '[^. \t]->\h\w*\|\h\w*::'

  " FOR clang_complete settings
  " let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  " let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_overwrite_completefunc = 1
  let g:neocomplete#force_omni_input_patterns.c =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
  let g:neocomplete#force_omni_input_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
  let g:neocomplete#force_omni_input_patterns.objc =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
  let g:neocomplete#force_omni_input_patterns.objcpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
  let g:clang_complete_auto = 0
  let g:clang_auto_select = 0
  if has("mac")
    let g:clang_library_path="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
  endif
  let g:clang_use_library = 1

  "For External plugin's completion
  " Go (plugin: gocode)
  let g:neocomplete#sources#omni#functions.go =
  \ 'gocomplete#Complete'
  " Clojure (plugin: vim-clojure)
  let g:neocomplete#sources#omni#functions.clojure =
  \ 'vimclojure#OmniCompletion'
  " SQL
  let g:neocomplete#sources#omni#functions.sql =
  \ 'sqlcomplete#Complete'
  " R (plugin: vim-R-plugin)
  let g:neocomplete#sources#omni#input_patterns.r =
  \ '[[:alnum:].\\]\+'
  let g:neocomplete#sources#omni#functions.r =
  \ 'rcomplete#CompleteR'
  " Rmd (plugin: vim-R-plugin)
  let g:neocomplete#sources#omni#input_patterns.rmd =
  \ '[[:alnum:].\\]\+'
  let g:neocomplete#sources#omni#functions.rmd =
  \ 'rcomplete#CompleteR'
  " XQuery (plugin: XQuery-indentomnicomplete)
  let g:neocomplete#sources#omni#input_patterns.xquery =
  \ '\k\|:\|\-\|&'
  let g:neocomplete#sources#omni#functions.xquery =
  \ 'xquerycomplete#CompleteXQuery'

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'
  let g:node_usejscomplete = 1
endif
"}}}
"
" neosnippet "{{{
" <C-J> にマッピング. スニペット補完
" Plugin key-mappings.
" imap <C-J> <Plug>(neosnippet_expand_or_jump)
smap <C-J> <Plug>(neosnippet_expand_or_jump)
xmap <C-J> <Plug>(neosnippet_expand_target)
"" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"
"" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" let g:neosnippet#snippets_directory=s:bundle_root
"}}}

" Unite Settings"{{{
" 入力モードで開始する
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1

" バッファ一覧
noremap <C-k><C-B> :<C-u>Unite buffer<CR>
" ファイル一覧
noremap <C-k><C-f> :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" 最近使ったファイルの一覧
noremap <C-k><C-N> :<C-u>Unite file_mru<CR>
" レジスタ一覧
noremap <C-k><C-R> :<C-u>Unite -buffer-name=register register<CR>
" ファイルとバッファ
noremap <C-k><C-k> :<C-u>Unite buffer file_mru<CR>
" 全部
noremap <C-k><C-A> :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" キーマップを表示
noremap <C-k><C-M> :<C-u>Unite mapping<CR>
" スクリプトを表示
noremap <C-k>s :<C-u>Unite scriptnames<CR>
" コマンドを表示
noremap <C-k>c :<C-u>Unite command<CR>
" ヤンクヒストリ
noremap <C-k><C-y> :<C-u>Unite history/yank<CR>
" ヘルプ参照
noremap <C-k><C-h> :<C-u>Unite help<CR>
" pydoc
noremap <C-k><C-d> :<C-u>Unite ref/pydoc<CR>
" カラースキーム
noremap <C-k><C-l> :<C-u>Unite colorscheme<CR>
" スニペット
imap <C-k><C-i> <Plug>(neosnippet_start_unite_snippet)
" todo
noremap <C-k><C-t> :<C-u>Unite todo<CR>
let g:unite_todo_note_suffix="md"
" Spotlight
noremap <C-k><C-p> :<C-u>Unite spotlight<CR>
" Outline
noremap <C-k><C-o> :<C-u>Unite outline<CR>
" unite-tag
autocmd BufEnter *
\   if empty(&buftype)
\|      nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
\|  endif
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
au FileType unite inoremap <silent> <buffer> <C-f> <ESC>
au FileType unite inoremap <silent> <buffer> <C-f><C-f> <ESC>:q<CR>
" 初期設定関数を起動する
au FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
" Overwrite settings.
endfunction"}}}

" colorscheme Settings"{{{
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_degrade=0
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
let g:solarized_contrast="high"
let g:solarized_visibility="high"
set background=dark
colorscheme solarized
call togglebg#map("")
" autocmd BufWinEnter,TabEnter,FileType *
"       \ if &ft!='python' |
"       \  let g:solarized_termcolors=256 |
"       \  let g:solarized_termtrans=1 |
"       \  let g:solarized_degrade=0 |
"       \  let g:solarized_bold=1 |
"       \  let g:solarized_underline=1 |
"       \  let g:solarized_italic=1 |
"       \  let g:solarized_contrast="high" |
"       \  let g:solarized_visibility="high" |
"       \  set background=dark |
"       \  colorscheme solarized |
"       \ else |
"       \   let g:molokai_original=0 |
"       \   let g:rehash256=0 |
"       \   colorscheme molokai |
"       \   set bg=dark |
"       \   set bg=light |
"       \ endif
"
"}}}

" foldCC Setings"{{{
set foldtext=FoldCCtext()
set foldcolumn=4
set fillchars=vert:\|
highlight Folded gui=bold term=standout ctermbg=Black ctermfg=DarkCyan guibg=#555555 guifg=DarkCyan
highlight FoldColumn gui=bold term=standout ctermbg=Black ctermfg=DarkBlue guibg=Black guifg=DarkBlue"}}}

" TODO Setting "{{{
noremap <Leader>t :noautocmd vimgrep /TODO/j **/*.r **/*.py<CR>:cw<CR>
syn match   Comment "#.*$" contains=Todo,@Spell
syn keyword Todo FIXME NOTE NOTES TODO XXX COMBAK BUG DEBUG HACK contained"}}}

" taglist"{{{
" let Tlist_Use_Right_Window = 1
" let Tlist_Display_Prototype = 1
" let Tlist_Display_Tag_Scope = 1
" let Tlist_Exit_OnlyWindow = 1
" let tlist_tex_settings = 'latex;s:sections;l:labels;r:ref;g:graphic+listing'
" let tlist_r_settings = 'R;f:Functions;g:GlobalVariables;v:FunctionVariables'
" let tlist_rmd_settings = 'R;f:Functions;g:GlobalVariables;v:FunctionVariables'
" set title titlestring=%<%f\ %([%{Tlist_Get_Tagname_By_Line()}]%)
" set statusline=%<%f%=%([%{Tlist_Get_Tagname_By_Line()}]%)"}}}

" tagbar"{{{
let g:tagbar_type_r = {
    \ 'ctagstype' : 'r',
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
        \ 'v:FunctionVariables',
    \ ]
\ }

let g:tagbar_type_rmd = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.vim/bundle/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
\ }

let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }

let g:tagbar_type_tex = {
    \ 'ctagstype' : 'latex',
    \ 'kinds'     : [
        \ 's:sections',
        \ 'l:labels',
        \ 'r:ref',
        \ 'g:graphic+listing'
    \]
\ }


let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.vim/bundle/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
let g:tagbar_type_javascript = {
    \ 'ctagstype': 'javascript',
    \ 'ctagsbin' : 'jsctags'
\ }
"}}}

" vim-latex"{{{
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'
let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
let g:Tex_BibtexFlavor = 'pbibtex'
let g:Tex_MakeIndexFlavor = 'mendex $*.idx'
let g:Tex_UseEditorSettingInDVIViewer = 1
let g:Tex_ViewRule_pdf = '/usr/bin/open -a Skim.app'
let g:Tex_ViewRule_ps = '/usr/bin/open'
let g:Tex_ViewRule_dvi = '/usr/bin/open'
"}}}

" lightline.vim Settings"{{{
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'virtualenv' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'virtualenv': 'MyVirtualenv',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? '⭠ '._ : ''
  endif
  return ''
endfunction

function! MyVirtualenv()
  if &ft !~? 'help\|vimfiler\|gundo' && exists("*virtualenv#statusline")
    let _ = virtualenv#statusline()
    return strlen(_) ? '✇ '._ : ''
  endif
  return ''
endfunction
" ✇☤⚒ ⚖ ⚚
function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
"}}}

" VimRepress Settings"{{{
function! VimpressSetting()
  BlogList
endfunction"}}}

" vim-session"{{{
" 現在のディレクトリ直下の .vimsessions/ を取得
let s:local_session_directory = xolox#misc#path#merge(getcwd(), '.vimsessions')
" 存在すれば
if isdirectory(s:local_session_directory)
  " session保存ディレクトリをそのディレクトリの設定
  let g:session_directory = s:local_session_directory
  " vimを辞める時に自動保存
  let g:session_autosave = 'yes'
  " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開く
  let g:session_autoload = 'yes'
  " 1分間に1回自動保存
  let g:session_autosave_periodic = 30
else
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif
unlet s:local_session_directory
"}}}

" vimux settings"{{{
" Prompt for a command to run
noremap <Leader>vc :VimuxPromptCommand<CR>
" Inspect runner pane
noremap <Leader>vi :VimuxInspectRunner<CR>
" Close vim tmux runner opened by VimuxRunCommand
noremap <Leader>vq :VimuxCloseRunner<CR>
" Zoom the runner pane (use <bind-key> z to restore runner pane)
noremap <Leader>vz :call VimuxZoomRunner()<CR>
" Vimux as tslime replacement
vnoremap <LocalLeader>vms "vy :call VimuxSlime()<CR>
" send current line
nmap <LocalLeader>se ^v$<LocalLeader>vms<CR>
" Select current paragraph and send it to tmux
nmap <LocalLeader>vb vip<LocalLeader>vms<CR>
" Vimux as tslime replacement
function! VimuxSlime()
  call VimuxSendText(@v)
  "  call VimuxSendKeys("Enter")
endfunction
" orientation of the split tmux pane
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"
" Vimux Prompt String
let g:VimuxPromptString = "cmd:""}}}

" Git settings"{{{
noremap gs :<C-u>Gstatus<CR>
noremap gw :<C-u>Gwrite<CR>
noremap gc :<C-u>Gcommit<CR>
noremap gp :<C-u>Git push<CR>
" :<C-u>GitPush<CR>
noremap gd :<C-u>Gdiff<CR>
noremap gb :<C-u>Gblame<CR>
"}}}

" indentLine"{{{
augroup precious-indentLine
  autocmd!
  " precious.vim が filetype を切り替える度に indentLine をリセットする
  autocmd User PreciousFileType IndentLinesReset
augroup END
"}}}

" syntastic"{{{
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '✑'
let g:syntastic_style_warning_symbol = '✏︎'
" ✍ ✏︎ ✒︎ ✄ ✂︎ ☕︎ ✑ ☹ ⚡︎ ☞
let g:syntastic_mode_map = { 'mode': 'passive',
      \ 'active_filetypes': ['ruby', 'c', 'go', 'php'],
      \ 'passive_filetypes': ['html']
      \}
" let g:syntastic_auto_loc_list=1
noremap \gs :<C-u>SyntasticToggleMode<CR>
noremap \gc :<C-u>SyntasticCheck<CR>
noremap \gl :<C-u>SyntasticSetLoclist<CR>
let g:syntastic_enable_highlighting=1
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_r_svtools_checker=1
let g:syntastic_enable_r_lint_checker=1
" let g:syntastic_r_lint_styles = 'list(spacing.indentation.notabs, spacing.indentation.evenindent)'
let g:syntastic_r_checkers = ['svtools', 'lint']
let g:syntastic_python_checker = 'flake8'
let g:syntastic_javascript_checker = "jshint"
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"}}}

" incsearch"{{{
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" let g:incsearch#auto_nohlsearch = 1
" map n  <Plug>(incsearch-nohl-n)
" map N  <Plug>(incsearch-nohl-N)
" map *  <Plug>(incsearch-nohl-*)
" map #  <Plug>(incsearch-nohl-#)
" map g* <Plug>(incsearch-nohl-g*)
" map g# <Plug>(incsearch-nohl-g#)
map z/ <Plug>(incsearch-fuzzyspell-/)
map z? <Plug>(incsearch-fuzzyspell-?)
map zg/ <Plug>(incsearch-fuzzyspell-stay)
map m/ <Plug>(incsearch-migemo-/)
map m? <Plug>(incsearch-migemo-?)
map mg/ <Plug>(incsearch-migemo-stay)

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())
"}}}

" easymotion"{{{
let g:EasyMotion_do_mapping = 0 "Disable default mappings
nmap , <Plug>(easymotion-s2)
map f <Plug>(easymotion-fl)
map t <Plug>(easymotion-tl)
map F <Plug>(easymotion-Fl)
map T <Plug>(easymotion-Tl)
omap <Leader>w <Plug>(easymotion-bd-wl)
omap <Leader>e <Plug>(easymotion-bd-el)
xmap , <Plug>(easymotion-s2)
" surround.vimと被らないように
omap z <Plug>(easymotion-s2)
" Jump to first match with enter & space
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_use_migemo = 1
" =======================================
" Search Motions
" =======================================
" Extend search motions with vital-over command line interface
" Incremental highlight of all the matches
" Now, you don't need to repetitively press `n` or `N` with EasyMotion feature
" `<Tab>` & `<S-Tab>` to scroll up/down a page of next match
" :h easymotion-command-line
nmap g/ <Plug>(easymotion-sn)
xmap g/ <Plug>(easymotion-sn)
omap g/ <Plug>(easymotion-tn)
" Repeat
map <Leader><Leader> <Plug>(easymotion-repeat)
" map <C-n> <Plug>(easymotion-next)
" map <C-p> <Plug>(easymotion-prev)
" map ; <Plug>(easymotion-next)
" map , <Plug>(easymotion-prev)
"}}}

" template"{{{
let g:templates_directory = ['~/.vim/templates/']
let g:templates_no_builtin_templates = 1
let g:templates_name_prefix = 'template.'
let g:templates_global_name_prefix = 'template.'
"}}}

" JSONFORMAT"{{{
command! JsonFormat :execute '%!python -m json.tool'
  \ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)), sys.stdin.read()))"'
  \ | :%s/ \+$//ge
  \ | :set ft=javascript
  \ | :1
"}}}

" rainbow parentheses"{{{
let g:rebpt_max = 16
let g:rbpt_loadcmd_toggle = 0

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
"}}}

" " SKK"{{{
" let g:skk_jisyo = '~/Library/Application\ Support/AquaSKK/skk-jisyo.utf8'
" let g:skk_large_jisyo = "~/Library/Application\ Support/AquaSKK/SKK-JISYO.L"
" " let g:skk_control_j_key = ''
" imap "" <Plug>(skk-toggle-im)
" let g:skk_auto_save_jisyo = 1
" let g:skk_keep_state = 1
" let g:skk_kutouten_type = 'en'
" let g:skk_use_color_cursor = 1
"}}}
