" PEP 8 Indent rule
setl tabstop=8
setl softtabstop=4
setl shiftwidth=4
setl smarttab
setl expandtab
setl autoindent
setl nosmartindent
setl cindent
setl textwidth=80
setl colorcolumn=80
set foldcolumn=5

" pep-8 check
let g:flake8_cmd="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/flake8"
nnoremap <C-P> :call Flake8()<CR>

" Folding
setl foldmethod=indent
setl foldlevel=99

" pyflakes-pathogen Settings
" let pyflakes_use_quickfix = 0

" nose.vim
compiler nose

" for jedi
let g:jedi#auto_initialization = 1
let g:jedi#rename_command = '<leader>R'
let g:jedi#goto_assignments_command = '<leader>G'
let g:jedi#popup_on_dot = 1
let g:jedi#popup_select_first = 0
" let g:jedi#show_function_definition = 1
" autocmd FileType python let b:did_ftplugin = 1

" vim-ipython command
nnoremap <buffer><C-t><C-r> :<C-u>py run_this_file()<CR>
nnoremap <buffer><C-t><C-t> :<C-u>py run_this_line()<CR>
vnoremap <buffer><C-t><C-t> :py run_these_lines()<CR>

" python-syntax
let OPTION_NAME = 1
let python_highlight_all = 1

" Indent-Guide
let g:indent_guides_auto_colors = 0
let g:indent_guides_color_change_percent = 10
autocmd VimEnter,Colorscheme,BufEnter,BufNewFile * :hi IndentGuidesOdd ctermbg=321 guibg=darkblue
autocmd VimEnter,Colorscheme,BufEnter,BufNewFile * :hi IndentGuidesEven ctermbg=446 guibg=darkgrey
let g:indent_guides_guide_size = 1 

let g:indent_guides_enable_on_vim_startup = 1

" colorscheme
