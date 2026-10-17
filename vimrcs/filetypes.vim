""""""""""""""""""""""""""""""
" => Filetype configurations
""""""""""""""""""""""""""""""

augroup vimrc_filetypes
    autocmd!

    " ----------------------------------------------------
    " Python
    " ----------------------------------------------------
    autocmd FileType python syn keyword pythonDecorator True None False self
    autocmd FileType python nnoremap <buffer> <leader>1 /class <cr>
    autocmd FileType python nnoremap <buffer> <leader>2 /def <cr>
    autocmd FileType python nnoremap <buffer> <leader>C ?class <cr>
    autocmd FileType python nnoremap <buffer> <leader>D ?def <cr>

    " ----------------------------------------------------
    " JavaScript / TypeScript
    " ----------------------------------------------------
    autocmd FileType javascript,typescript call s:JavaScriptSetup()

    " ----------------------------------------------------
    " CoffeeScript
    " ----------------------------------------------------
    autocmd FileType coffee call s:CoffeeScriptFold()

    " ----------------------------------------------------
    " Git Commit
    " ----------------------------------------------------
    autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

    " ----------------------------------------------------
    " Web templates & Markup
    " ----------------------------------------------------
    autocmd BufNewFile,BufRead *.jinja set syntax=htmljinja
    autocmd BufNewFile,BufRead *.mako set ft=mako
    autocmd BufNewFile,BufRead *.twig set syntax=html filetype=html

    " ----------------------------------------------------
    " YAML / TOML / JSON
    " ----------------------------------------------------
    autocmd FileType yaml,toml,json setlocal ts=2 sts=2 sw=2 expandtab
augroup END

let python_highlight_all = 1
let vim_markdown_folding_disabled = 1

function! s:JavaScriptFoldText() abort
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
endfunction

function! s:JavaScriptSetup() abort
    setlocal foldmethod=syntax
    setlocal foldlevelstart=1
    setlocal foldenable
    setlocal nocindent
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
    setlocal foldtext=s:JavaScriptFoldText()
endfunction

function! s:CoffeeScriptFold() abort
    setlocal foldmethod=indent
    setlocal foldlevelstart=1
endfunction
