
inoremap <buffer> _ <ESC>:call ReplaceUnderS()<CR>a
" Vim-R-plugin
let vimrplugin_vsplit = 1
let vimrplugin_rconsole_width = 80
let vimrplugin_listmethods = 1
let vimrplugin_start_libs = "base,stats,graphics,grDevices,utils,methods"

" Run the current file
noremap <silent> <Leader>vx :call VimuxRunCommand("source('" . bufname("%") . "')")<CR>
