"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requires that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Load packages via native Vim package mechanism (Vim 8 & 9)
""""""""""""""""""""""""""""""
let s:vim_runtime = expand('<sfile>:p:h:h')

if &packpath !~# escape(s:vim_runtime, '\')
    execute 'set packpath^=' . fnameescape(s:vim_runtime)
endif

" Load native packages if not yet loaded
if exists(':packloadall')
    silent! packloadall
endif

" Backward compatibility: load plugins in my_plugins/ if any exist
if isdirectory(s:vim_runtime . '/my_plugins')
    for s:plugin_dir in glob(s:vim_runtime . '/my_plugins/*', 1, 1)
        if isdirectory(s:plugin_dir)
            execute 'set runtimepath+=' . fnameescape(s:plugin_dir)
        endif
    endfor
endif


""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>m :MRU<CR>


""""""""""""""""""""""""""""""
" => YankStack
""""""""""""""""""""""""""""""
let g:yankstack_yank_keys = ['y', 'd']

nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste


""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

" Quickly find and open a file in the current working directory
let g:ctrlp_map = '<C-f>'
map <leader>j :CtrlP<cr>

" Quickly find and open a buffer
map <leader>b :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'


""""""""""""""""""""""""""""""
" => ZenCoding
""""""""""""""""""""""""""""""
" Enable all functions in all modes
let g:user_zen_mode='a'


""""""""""""""""""""""""""""""
" => snipMate (beside <TAB> support <CTRL-j>)
""""""""""""""""""""""""""""""
ino <C-j> <C-r>=snipMate#TriggerSnippet()<cr>
snor <C-j> <esc>i<right><C-r>=snipMate#TriggerSnippet()<cr>
let g:snipMate = { 'snippet_version' : 1 }


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-s>'
let g:multi_cursor_select_all_word_key = '<A-s>'
let g:multi_cursor_start_key           = 'g<C-s>'
let g:multi_cursor_select_all_key      = 'g<A-s>'
let g:multi_cursor_next_key            = '<C-s>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"\ue0a2":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead") && ""!=FugitiveHead() ? "\ue0a0 " . FugitiveHead() : ""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimroom
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale (syntax checker and linter)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'python': ['ruff', 'flake8'],
\   'go': ['golangci-lint', 'go'],
\   'rust': ['cargo'],
\   'verilog': ['verilator'],
\   'verilog_systemverilog': ['verilator'],
\}

nmap <silent> <leader>a <Plug>(ale_next_wrap)

" Disabling highlighting
let g:ale_set_highlights = 0

" Only run linting when saving the file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_virtualtext_cursor = 'disabled'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=0
nnoremap <silent> <leader>d :GitGutterToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => EditorConfig (project-specific EditorConfig rule)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EditorConfig_exclude_patterns = ['fugitive://.*']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fugitive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy the link to the line of a Git repository to the clipboard
nnoremap <leader>v :.GBrowse!<CR>
xnoremap <leader>v :GBrowse!<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => LargeFile (protect against freeze on EDA logs/waveforms)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable syntax highlighting, undo, swapfile for files >= 50MB
let g:LargeFile = 50


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Verilog / SystemVerilog (vhda/verilog_systemverilog.vim)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable eos indentation so closing ');' aligns with module/task/function header
let g:verilog_disable_indent_lst = 'eos'

" Navigation mappings for Verilog / SystemVerilog buffers
augroup VerilogNavigation
    autocmd!
    autocmd FileType verilog,verilog_systemverilog,systemverilog nnoremap <buffer><silent> <leader>i :VerilogFollowInstance<CR>
    autocmd FileType verilog,verilog_systemverilog,systemverilog nnoremap <buffer><silent> <leader>I :VerilogFollowPort<CR>
    autocmd FileType verilog,verilog_systemverilog,systemverilog nnoremap <buffer><silent> <leader>u :VerilogGotoInstanceStart<CR>
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tabular (code alignment)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode alignments (especially handy for RTL port lists and assignments)
vnoremap <leader>a= :Tabularize /=<CR>
vnoremap <leader>a< :Tabularize /<=<CR>
vnoremap <leader>a: :Tabularize /:<CR>
vnoremap <leader>a, :Tabularize /,<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => LeaderF (fast fuzzy search)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_ShortcutB = '<leader>fb'
noremap <leader>fm :Leaderf mru<CR>
noremap <leader>ft :Leaderf bufTag<CR>
noremap <leader>fl :Leaderf line<CR>
noremap <leader>fg :Leaderf rg<CR>

" Window position: use modern popup in Vim 8.1.1615+ / Neovim, bottom split in Vim 8.0.1763
if exists('*popup_create') || has('nvim-0.4.2')
    let g:Lf_WindowPosition = 'popup'
    let g:Lf_PreviewInPopup = 1
else
    let g:Lf_WindowPosition = 'bottom'
    let g:Lf_PreviewInPopup = 0
endif

let g:Lf_HideHelp = 1
let g:Lf_UseCache = 1
let g:Lf_UseVersionControlTool = 1
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_ShowDevIcons = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2" }

" Ignore version control, build dirs, and EDA simulation/waveform artifacts
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn', '.git', '.hg', 'csrc', '*.daidir', 'work', 'INCA_libs', 'AN.DB', 'DVEfiles', '__pycache__', 'build', 'dist'],
    \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]', '*.fsdb', '*.vcd', '*.vpd', '*.wlf', '*.log', 'novas.*']
    \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Generate helptags on demand (no need to run on every startup)
command! GenerateHelpTags execute 'helptags ALL'
