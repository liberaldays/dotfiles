" First setings"{{{
set t_Co=256
set tags=tags
let Tlist_Ctags_Cmd = "/opt/local/bin/ctags"  " ctagsのコマンド
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

filetype on
filetype indent on
filetype plugin on
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

  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

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

else

  set autoindent " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
end

" 戦闘力
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
inoremap <C-A> <Home>
inoremap <C-E> <End>
inoremap <C-D> <Del>
inoremap <C-W> <BS>

inoremap <C-H> <Left>
" inoremap <C-J> <Down>
" inoremap <C-K> <Up>
inoremap <C-L> <Right>

noremap ; :
noremap : ;
noremap j gj
noremap k gk
inoremap <C-f> <ESC>
cnoremap <C-f> <ESC>
lnoremap <C-f> <ESC>
noremap <Esc><Esc> :nohlsearch<CR>

" Open vimrc
nnoremap <silent> <Space>. :<C-u>tabedit ~/dotfiles/_vimrc<CR>:<C-u>lcd %:p:h<CR>
nnoremap <silent> <Space>s. :<C-u>source $MYVIMRC<CR>

noremap tL :<C-u>Tlist<CR>
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
inoremap {} {}<Left>
inoremap [] []<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap <> <><Left>
vnoremap {} di{<Esc>pa}<Esc>
vnoremap [] di[<Esc>pa]<Esc>
vnoremap () di(<Esc>pa)<Esc>
vnoremap "" di"<Esc>pa"<Esc>
vnoremap '' di'<Esc>pa'<Esc>
vnoremap <> di<<Esc>pa><Esc>

" Gundo Toggle ==UndoTree==
nnoremap tu :GundoToggle<CR>

"}}}

" NeoBundle"{{{
filetype off
 if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle.vim/
   call neobundle#rc(expand('~/.vim/bundle/'))
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
 NeoBundle 'zhaocai/unite-scriptnames'
 NeoBundle 'h1mesuke/unite-outline'
 NeoBundle 'tsukkee/unite-tag'
 NeoBundle 'osyo-manga/unite-fold'
 NeoBundle 'tsukkee/unite-help'
 NeoBundle 'kana/vim-vspec'
 NeoBundle 'basyura/TweetVim' " twitter client for vim
 NeoBundleLazy 'mattn/webapi-vim'
 NeoBundleLazy 'basyura/twibill.vim'
 NeoBundleLazy 'basyura/bitly.vim'
 NeoBundleLazy 'osyo-manga/TweetVim-powerline-theme'
 NeoBundleLazy 'yomi322/unite-tweetvim' " unite source for tweetvim
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
 NeoBundle 'ujihisa/unite-colorscheme'
 NeoBundle 'Shougo/vimproc', { 'build' : {
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
 NeoBundle 'mitechie/pyflakes-pathogen'
"  NeoBundle 'vim-scripts/pythoncomplete'
 NeoBundleLazy 'lambdalisue/vim-django-support'
 NeoBundle 'reinh/vim-makegreen'
 NeoBundle 'lambdalisue/nose.vim'
 NeoBundle 'alfredodeza/pytest.vim'
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
 NeoBundle 'nvie/vim-flake8'
 NeoBundle 'hdima/python-syntax'
 " NeoBundle 'nathanaelkane/vim-indent-guides'
 NeoBundleLazy 'Yggdroot/indentLine', {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \ }}
 NeoBundle 'thinca/vim-ref'
 " NeoBundle 'TwitVim'
 " NeoBundle 'jcfaria/Vim-R-plugin'
 NeoBundle 'vim-scripts/Vim-R-plugin'
 NeoBundle 'itchyny/lightline.vim'
 NeoBundle 'taglist.vim'
 NeoBundle 'sophacles/vim-processing'
 NeoBundleLazy 'git://git.code.sf.net/p/vim-latex/vim-latex', {
       \ "autoload": {
       \   "filetypes": ["tex"],
       \ }}
 NeoBundle 'vim-scripts/R-syntax-highlighting'
 NeoBundle 'LeafCage/foldCC'
 NeoBundle 'motemen/git-vim'
 NeoBundle 'tpope/vim-fugitive'
 NeoBundle 'xolox/vim-reload'
 NeoBundle 'xolox/vim-misc'
 NeoBundle 'pentie/VimRepress'
 NeoBundle 'tpope/vim-markdown'
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
 filetype on
 filetype plugin indent on
 NeoBundleCheck"}}}

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
            \   'cmdopt' : '-c',
            \   'outputter' : 'error',
            \   'outputter/error/error' : 'quickfix',
            \   'exec': ['%c']
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
            \   'exec': '%c --from=markdown --to=html %o %s %a',
            \ },
            \ 'python' : {
            \   'command' : 'python2.7',
            \ }}
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
set splitright
"}}}

" " powerline - settings"{{{
" " font
" " フォントサイズ
" set guifont=Ricty_for_Powerline:h10
" " こっちは日本語フォント
" set guifontwide=Ricty:h10
" " " `fancy' テーマに切り替え
" let g:Powerline_symbols = 'fancy'"}}}

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
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
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
  "let g:clang_use_library = 1

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
  " XQuery (plugin: XQuery-indentomnicomplete)
  let g:neocomplete#sources#omni#input_patterns.xquery =
  \ '\k\|:\|\-\|&'
  let g:neocomplete#sources#omni#functions.xquery =
  \ 'xquerycomplete#CompleteXQuery'

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
endif
"}}}
"
" neosnippet "{{{
" <C-J> にマッピング. スニペット補完
" Plugin key-mappings.
imap <C-J> <Plug>(neosnippet_expand_or_jump)
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
" カラースキーム
noremap <C-k><C-l> :<C-u>Unite colorscheme<CR>
" スニペット
imap <C-k><C-i> <Plug>(neosnippet_start_unite_snippet)
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
let Tlist_Display_Tag_Scope = 1
let Tlist_Exit_OnlyWindow = 1
let tlist_tex_settings = 'latex;s:sections;l:labels;r:ref;g:graphic+listing'
let tlist_r_settings = 'R;f:Functions;g:GlobalVariables;v:FunctionVariables'
set title titlestring=%<%f\ %([%{Tlist_Get_Tagname_By_Line()}]%)
set statusline=%<%f%=%([%{Tlist_Get_Tagname_By_Line()}]%)"}}}

" vim-latex"{{{
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_CompileRule_dvi = '/opt/local/bin/platex --interaction=nonstopmode $*'
let g:Tex_CompileRule_pdf = '/opt/local/bin/dvipdfmx $*.dvi'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
let g:Tex_BibtexFlavor = '/opt/local/bin/pbibtex'
let g:Tex_MakeIndexFlavor = '/opt/local/bin/mendex $*.idx'
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
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
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
if &ft!='python'
  " Run bpython
  noremap <Leader>vp :call VimuxRunCommand("ipython")<CR>
  " Run the current file
  noremap <silent> <Leader>vx :call VimuxRunCommand("execfile('" . bufname("%") . "')")<CR>
  " Prompt for a command to run
  noremap <Leader>vc :VimuxPromptCommand<CR>
  " Inspect runner pane
  noremap <Leader>vi :VimuxInspectRunner<CR>
  " Close vim tmux runner opened by VimuxRunCommand
  noremap <Leader>vq :VimuxCloseRunner<CR>
  " Zoom the runner pane (use <bind-key> z to restore runner pane)
  noremap <Leader>vz :call VimuxZoomRunner()<CR>
  " Vimux as tslime replacement
  function! VimuxSlime()
    call VimuxSendText(@v)
    "  call VimuxSendKeys("Enter")
  endfunction
  " If text is selected, save it in the v buffer and send that buffer it to tmux
  vnoremap <LocalLeader>vs "vy :call VimuxSlime()<CR>
  " send current line
  nmap <LocalLeader>d ^v$<LocalLeader>vs<CR>
  " Select current paragraph and send it to tmux
  nmap <LocalLeader>vb vip<LocalLeader>vs<CR>
endif
" orientation of the split tmux pane
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"
" Vimux Prompt String
let g:VimuxPromptString = "cmd:""}}}
