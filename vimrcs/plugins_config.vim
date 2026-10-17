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
if !exists('g:snipMate')
    let g:snipMate = {}
endif
let g:snipMate.snippet_version = 1


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

" Default mapping (using Ctrl-n to avoid terminal Ctrl-s conflicts and match modern IDEs)
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
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
" => auto-pairs (Verilog / SystemVerilog optimization)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Exclude single quote (') and backtick (`) in Verilog/SystemVerilog
" to prevent auto-closing from breaking 1'b0 and `define macros
augroup AutoPairsVerilog
    autocmd!
    autocmd FileType verilog,verilog_systemverilog,systemverilog let b:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"'}
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], ['fileformat', 'fileencoding', 'filetype'] ]
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
\   'perl': ['perl'],
\}

" Verilog / SystemVerilog verilator options for modern SV & linting
let g:ale_verilog_verilator_options = '-Wall -Wno-fatal -sv -Wno-DECLFILENAME'

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
vnoremap <leader>a( :Tabularize /(<CR>


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
" => Helper commands & Performance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Generate helptags on demand (no need to run on every startup)
command! GenerateHelpTags execute 'helptags ALL'

" Fast syntax highlighting: avoid freezing on ultra-long lines (e.g. minified netlists)
set synmaxcol=500

" Disable cursorcolumn in insert mode to eliminate input latency on remote VNC/SSH
augroup RemoteCursorPerformance
    autocmd!
    autocmd InsertEnter * if &cursorcolumn | let b:restore_cc = 1 | setlocal nocursorcolumn | endif
    autocmd InsertLeave * if get(b:, 'restore_cc', 0) | setlocal cursorcolumn | unlet b:restore_cc | endif
augroup END

" Clean trailing whitespace across current file while preserving cursor position
function! s:CleanTrailingWhitespace() abort
    let l:save_view = winsaveview()
    silent! %s/\s\+$//e
    call winrestview(l:save_view)
    echo "Trailing whitespace cleaned."
endfunction
command! CleanTrailingWS call <SID>CleanTrailingWhitespace()
nnoremap <silent> <leader>cw :CleanTrailingWS<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Floaterm (terminal management)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Adapt window type: bottom split drawer on Vim 8.0, popup float on Vim 8.2+ / Neovim
if !has('patch-8.2.0286') && !has('nvim')
    let g:floaterm_wintype = 'split'
    let g:floaterm_position = 'botright'
    let g:floaterm_height = 0.35
else
    let g:floaterm_wintype = 'float'
    let g:floaterm_width = 0.85
    let g:floaterm_height = 0.85
    let g:floaterm_title = 'Terminal ($1/$2)'
endif

let g:floaterm_autoinsert = 1
let g:floaterm_autoclose = 1

" Function key bindings
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_keymap_new    = '<F9>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F10>'

" Leader-based shortcuts
nnoremap <silent> <leader>tt :FloatermToggle<CR>
tnoremap <silent> <leader>tt <C-\><C-n>:FloatermToggle<CR>
nnoremap <silent> <leader>tn :FloatermNew<CR>
vnoremap <silent> <leader>ts :FloatermSend<CR>

" Quick escape to Terminal-Normal mode to scroll/copy terminal text
tnoremap <Esc><Esc> <C-\><C-n>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tagbar (Code structure outline for Verilog/SV, TCL, Perl)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <F4> :TagbarToggle<CR>
let g:tagbar_width = 30
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0  " Preserve file declaration order

" Verilog & SystemVerilog ctags definition for Tagbar
let g:tagbar_type_verilog = {
    \ 'ctagstype': 'verilog',
    \ 'kinds': [
        \ 'm:modules',
        \ 'i:interfaces',
        \ 'p:packages',
        \ 'c:classes',
        \ 't:tasks',
        \ 'f:functions',
        \ 'r:registers',
        \ 'w:wires',
        \ 'e:typedefs',
        \ 'd:defines'
    \ ]
\ }
let g:tagbar_type_systemverilog = g:tagbar_type_verilog
let g:tagbar_type_verilog_systemverilog = g:tagbar_type_verilog


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-dirdiff (Directory recursion diff for IC regression)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:DirDiffExcludes = ".git,work,csrc,*.daidir,*.o,*.so,novas.*,*.fsdb,*.vcd,*.vpd,build,dist"
let g:DirDiffIgnore = "Id:.*$"
let g:DirDiffSort = 1
let g:DirDiffWindowSize = 14


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-buftabline (IDE-like top visual buffer tabs)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display ordinal numbers (1, 2, 3...) from left to right
let g:buftabline_numbers = 2

" Show + indicator for modified/unsaved files
let g:buftabline_indicators = 1

" Show clean separators between tabs
let g:buftabline_separators = 1

" Always show the tabline at top like modern IDEs
let g:buftabline_show = 2

" Jump directly to visual tab 1..10 with <leader>1 .. <leader>0
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)

" Cycle through tabs with Ctrl-PageDown / Ctrl-PageUp
nnoremap <silent> <C-PageDown> :bnext<CR>
nnoremap <silent> <C-PageUp> :bprevious<CR>

" Aesthetic highlights for buftabline matching Gruvbox
function! s:SetupBufTabLineColors() abort
    hi BufTabLineCurrent cterm=bold gui=bold ctermfg=223 ctermbg=239 guifg=#ebdbb2 guibg=#504945
    hi BufTabLineHidden  cterm=NONE gui=NONE ctermfg=246 ctermbg=237 guifg=#a89984 guibg=#3c3836
    hi BufTabLineActive  cterm=NONE gui=NONE ctermfg=214 ctermbg=238 guifg=#fabd2f guibg=#3c3836
    hi BufTabLineFill    cterm=NONE gui=NONE ctermfg=241 ctermbg=235 guifg=#665c54 guibg=#282828
endfunction
augroup BufTabLineColors
    autocmd!
    autocmd ColorScheme,VimEnter * call s:SetupBufTabLineColors()
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDCommenter (Full-featured professional commenting)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add spaces after comment delimiters by default (// code instead of //code)
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a visual block)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines
let g:NERDToggleCheckAllLines = 1

" Map 'gc' in normal and visual mode to NERDCommenterToggle for quick toggle
nmap gc <Plug>NERDCommenterToggle
vmap gc <Plug>NERDCommenterToggle


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => SuperTab (All-in-one Smart Tab completion)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use context-aware completion:
" - After path '/', auto-completes filenames (<C-x><C-f>)
" - After '.', '::', '->', auto-completes omni/user methods
" - Otherwise, auto-completes buffer & project keywords downwards (<C-n>)
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

" Close preview scratch window automatically when completion popup menu closes
let g:SuperTabClosePreviewOnPopupClose = 1

" Retain completion mode only for current completion
let g:SuperTabRetainCompletionDuration = 'completion'
