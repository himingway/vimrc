"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important: 
"       This requires that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system (prioritizing JetBrains Mono NL Nerd Font Mono and Hack)
if has("mac") || has("macunix")
    set gfn=JetBrainsMonoNL\ Nerd\ Font\ Mono:h13,JetBrainsMonoNL\ NFM:h13,Hack\ Nerd\ Font\ Mono:h13,JetBrains\ Mono\ NL:h13,Hack:h13,Source\ Code\ Pro:h14,Menlo:h15
elseif has("win16") || has("win32") || has("win64")
    set gfn=JetBrainsMonoNL\ Nerd\ Font\ Mono:h13,JetBrainsMonoNL\ NFM:h13,Hack\ Nerd\ Font\ Mono:h13,JetBrains\ Mono\ NL:h13,Hack:h13,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2") || has("gui_gtk3") || has("linux")
    set gfn=JetBrainsMonoNL\ Nerd\ Font\ Mono\ 13,JetBrainsMonoNL\ NFM\ 13,Hack\ Nerd\ Font\ Mono\ 13,JetBrains\ Mono\ NL\ 13,Hack\ 13,IBM\ Plex\ Mono\ 13,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=JetBrainsMonoNL\ Nerd\ Font\ Mono\ 13,Hack\ Nerd\ Font\ Mono\ 13,Monospace\ 11
endif

" Load matchit (allows % to jump between begin/end, module/endmodule, class/endclass, `ifdef/`endif)
if !exists('g:loaded_matchit') && findfile('macros/matchit.vim', &runtimepath) !=# ''
    runtime macros/matchit.vim
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
    elseif &filetype =~# '^\%(verilog\|systemverilog\|verilog_systemverilog\)$'
        if executable('iverilog')
            let l:cmd = 'iverilog -g2012 ' . l:file . ' -o ' . l:out . ' && vvp ' . l:out
        elseif executable('verilator')
            let l:cmd = 'verilator --lint-only -Wall -sv ' . l:file
        endif
    elseif &filetype ==# 'tcl'
        let l:cmd = 'tclsh ' . l:file
    elseif &filetype ==# 'perl'
        let l:cmd = 'perl ' . l:file
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => EDA Radix & Bit-Width Converter (Hex <-> Dec <-> Bin)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:Num2Bin(n) abort
    if a:n == 0 | return '0000' | endif
    let l:val = a:n
    let l:res = ''
    let l:cnt = 0
    while l:val > 0
        let l:res = (l:val % 2) . l:res
        let l:val = l:val / 2
        let l:cnt += 1
        if l:cnt % 4 == 0 && l:val > 0
            let l:res = '_' . l:res
        endif
    endwhile
    let l:rem = l:cnt % 4
    if l:rem != 0
        let l:res = repeat('0', 4 - l:rem) . l:res
    endif
    return l:res
endfunction

function! s:GetBitWidth(n) abort
    if a:n <= 0 | return 1 | endif
    let l:val = a:n
    let l:w = 0
    while l:val > 0
        let l:w += 1
        let l:val = l:val / 2
    endwhile
    return l:w
endfunction

function! s:FormatHex32(n) abort
    let l:h = printf('%08X', a:n)
    return l:h[0:3] . '_' . l:h[4:7]
endfunction

function! s:ParseNumber(raw) abort
    let l:str = substitute(a:raw, '_', '', 'g')
    let l:val = 0
    let l:has_size = 0
    let l:size = 0
    if l:str =~? '\v^\d+''[hHbBdDoO]'
        let l:size = str2nr(matchstr(l:str, '\v^\d+'))
        let l:has_size = 1
    endif

    if l:str =~? '\v''[hH]'
        let l:val = str2nr(matchstr(l:str, '\v''[hH]\zs.*'), 16)
    elseif l:str =~? '\v''[bB]'
        let l:val = str2nr(matchstr(l:str, '\v''[bB]\zs.*'), 2)
    elseif l:str =~? '\v''[dD]'
        let l:val = str2nr(matchstr(l:str, '\v''[dD]\zs.*'), 10)
    elseif l:str =~? '\v''[oO]'
        let l:val = str2nr(matchstr(l:str, '\v''[oO]\zs.*'), 8)
    elseif l:str =~? '\v^0[xX]'
        let l:val = str2nr(l:str[2:], 16)
    elseif l:str =~? '\v^0[bB]'
        let l:val = str2nr(l:str[2:], 2)
    else
        let l:val = str2nr(l:str, 10)
    endif
    return [l:val, l:has_size, l:size]
endfunction

function! s:GetNumberUnderCursor() abort
    let l:line = getline('.')
    let l:col = col('.')
    let l:pattern = '\v(\d*''[hHbBdDoO][0-9a-fA-F_]+|0[xX][0-9a-fA-F_]+|0[bB][01_]+|-?\d[0-9_]*)'
    let l:start = 0
    while 1
        let l:m = matchstrpos(l:line, l:pattern, l:start)
        if empty(l:m[0])
            break
        endif
        let [l:token, l:s, l:e] = [l:m[0], l:m[1] + 1, l:m[2]]
        if l:col >= l:s && l:col <= l:e
            return [l:token, l:s, l:e]
        endif
        let l:start = l:m[2]
    endwhile
    let l:word = expand('<cword>')
    return [l:word, l:col, l:col + len(l:word)]
endfunction

function! RadixInspect(raw) abort
    let l:raw = empty(a:raw) ? s:GetNumberUnderCursor()[0] : a:raw
    if empty(l:raw)
        echo 'Radix: no number under cursor'
        return
    endif
    let [l:val, l:has_size, l:size] = s:ParseNumber(l:raw)
    let l:width = s:GetBitWidth(l:val)
    let l:bin = s:Num2Bin(l:val)
    let l:hex32 = s:FormatHex32(l:val)
    let l:bits_desc = l:has_size ? printf('%d bits (spec: %d)', l:width, l:size) : printf('%d bits [%d:0]', l:width, max([0, l:width - 1]))
    redraw
    echohl Title
    echo '[Radix] '
    echohl None
    echon printf('Dec: %d  |  Hex: 0x%X (32''h%s)  |  Bin: ''b%s  |  %s', l:val, l:val, l:hex32, l:bin, l:bits_desc)
endfunction

function! s:ReplaceCursorToken(new_str) abort
    let [l:token, l:s, l:e] = s:GetNumberUnderCursor()
    if empty(l:token) | return | endif
    let l:line = getline('.')
    let l:newline = (l:s > 1 ? l:line[0 : l:s-2] : '') . a:new_str . l:line[l:e :]
    call setline('.', l:newline)
    echo 'Replaced: ' . l:token . ' -> ' . a:new_str
endfunction

function! RadixToHex() abort
    let [l:token, l:s, l:e] = s:GetNumberUnderCursor()
    if empty(l:token) | return | endif
    let [l:val, l:has_size, l:size] = s:ParseNumber(l:token)
    let l:new_str = l:has_size ? printf('%d''h%X', l:size, l:val) : printf('0x%X', l:val)
    call s:ReplaceCursorToken(l:new_str)
endfunction

function! RadixToDec() abort
    let [l:token, l:s, l:e] = s:GetNumberUnderCursor()
    if empty(l:token) | return | endif
    let [l:val, l:has_size, l:size] = s:ParseNumber(l:token)
    let l:new_str = l:has_size ? printf('%d''d%d', l:size, l:val) : printf('%d', l:val)
    call s:ReplaceCursorToken(l:new_str)
endfunction

function! RadixToBin() abort
    let [l:token, l:s, l:e] = s:GetNumberUnderCursor()
    if empty(l:token) | return | endif
    let [l:val, l:has_size, l:size] = s:ParseNumber(l:token)
    let l:bin = s:Num2Bin(l:val)
    let l:new_str = l:has_size ? printf('%d''b%s', l:size, l:bin) : printf('''b%s', l:bin)
    call s:ReplaceCursorToken(l:new_str)
endfunction

command! -nargs=? Radix call RadixInspect(<q-args>)
command! RadixToHex call RadixToHex()
command! RadixToDec call RadixToDec()
command! RadixToBin call RadixToBin()

nnoremap <silent> <leader>cv :call RadixInspect('')<CR>
vnoremap <silent> <leader>cv "zy:call RadixInspect(@z)<CR>
nnoremap <silent> <leader>cx :call RadixToHex()<CR>
nnoremap <silent> <leader>cn :call RadixToDec()<CR>
nnoremap <silent> <leader>cb :call RadixToBin()<CR>
