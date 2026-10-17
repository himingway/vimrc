"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important: 
"       This requires that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system (prioritizing JetBrains Mono NL and Hack)
if has("mac") || has("macunix")
    set gfn=JetBrains\ Mono\ NL:h13,JetBrains\ Mono:h13,Hack:h13,IBM\ Plex\ Mono:h13,Source\ Code\ Pro:h14,Menlo:h15
elseif has("win16") || has("win32") || has("win64")
    set gfn=JetBrains\ Mono\ NL:h13,JetBrains\ Mono:h13,Hack:h13,IBM\ Plex\ Mono:h13,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2") || has("gui_gtk3") || has("linux")
    set gfn=JetBrains\ Mono\ NL\ 13,JetBrains\ Mono\ 13,Hack\ 13,IBM\ Plex\ Mono\ 13,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=JetBrains\ Mono\ NL\ 13,Hack\ 13,Monospace\ 11
endif

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Colorscheme
set background=dark
colorscheme peaksea


let s:vim_runtime = expand('<sfile>:p:h:h')
execute 'nnoremap <leader>e :e! ' . fnameescape(s:vim_runtime . '/my_configs.vim') . '<cr>'
augroup vimrc_myconfigs
    autocmd!
    execute 'autocmd BufWritePost ' . fnameescape(s:vim_runtime . '/my_configs.vim') . ' nested source ' . fnameescape(s:vim_runtime . '/my_configs.vim')
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on 
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    let s:undodir = s:vim_runtime . '/temp_dirs/undodir'
    if !isdirectory(s:undodir)
        call mkdir(s:undodir, 'p')
    endif
    let &undodir = s:undodir
    set undofile
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash 
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a`<esc>`<i`<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <C-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc_omnifunc
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack 

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

" Make sure that enter is never overriden in the quickfix window
augroup vimrc_quickfix
    autocmd!
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif   

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . escape(expand("%:p:h"), " ") . "/"
endfunc

"=================================================================================
"
"   Following file contains the commands on how to run the currently open code.
"   The default mapping is set to F5 like most code editors.
"   Change it as you feel comfortable with, keeping in mind that it does not
"   clash with any other keymapping.
"
"   NOTE: Compilers for different systems may differ. For example, in the case
"   of C and C++, we have assumed it to be gcc and g++ respectively, but it may
"   not be the same. It is suggested to check first if the compilers are installed
"   before running the code, or maybe even switch to a different compiler.
"
"   NOTE: Adding support for more programming languages
"
"   Just add another elseif block before the 'endif' statement in the same
"   way it is done in each case. Take care to add tabbed spaces after each
"   elseif block (similar to python). For example:
"
"   elseif &filetype == '<your_file_extension>'
"       exec '!<your_compiler> %'
"
"   NOTE: The '%' sign indicates the name of the currently open file with extension.
"         The time command displays the time taken for execution. Remove the
"         time command if you dont want the system to display the time
"
"=================================================================================

nnoremap <F5> :call CompileRun()<CR>
inoremap <F5> <Esc>:call CompileRun()<CR>
vnoremap <F5> <Esc>:call CompileRun()<CR>

function! CompileRun() abort
    silent! write
    let l:cmd = ''
    let l:file = shellescape(expand('%'))
    let l:out = shellescape(expand('%<'))

    if &filetype ==# 'c'
        let l:cmd = 'gcc -Wall ' . l:file . ' -o ' . l:out . ' && ./' . l:out
    elseif &filetype ==# 'cpp'
        let l:cmd = 'g++ -Wall ' . l:file . ' -o ' . l:out . ' && ./' . l:out
    elseif &filetype ==# 'java'
        let l:cmd = 'javac ' . l:file . ' && java ' . l:out
    elseif &filetype ==# 'sh'
        let l:cmd = 'bash ' . l:file
    elseif &filetype ==# 'python'
        let l:cmd = 'python3 ' . l:file
    elseif &filetype ==# 'go'
        let l:cmd = 'go run ' . l:file
    elseif &filetype ==# 'rust'
        let l:cmd = 'cargo run 2>/dev/null || (rustc ' . l:file . ' -o ' . l:out . ' && ./' . l:out . ')'
    elseif &filetype ==# 'javascript'
        let l:cmd = 'node ' . l:file
    elseif &filetype ==# 'typescript'
        let l:cmd = 'npx ts-node ' . l:file
    elseif &filetype ==# 'matlab'
        let l:cmd = 'octave ' . l:file
    endif

    if empty(l:cmd)
        echo 'CompileRun: unsupported filetype "' . &filetype . '"'
        return
    endif

    if has('terminal')
        " Vim 8 & 9 native asynchronous terminal
        if has('patch-8.0.0976')
            execute 'botright terminal ++rows=12 ' . l:cmd
        else
            execute 'botright terminal ' . l:cmd
        endif
    else
        execute '!' . l:cmd
    endif
endfunction
