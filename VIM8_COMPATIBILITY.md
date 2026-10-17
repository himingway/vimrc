# Vim 8.0 Compatibility & Stabilization Log

This document records all modifications, bug fixes, and architectural adjustments made to ensure 100% robust compatibility with **Vim / gVim 8.0** (specifically targeting enterprise enterprise Linux environments such as **RHEL 8 / CentOS 8**, running Vim 8.0.1763 in offline EDA/VNC/SSH workflows).

---

## 1. Native Package Architecture (`pack/vendor/start/`)
* **Background**: Older setups relied on legacy `tpope/vim-pathogen` and custom bundle directories (`sources_non_forked`).
* **Adjustment**:
  * Migrated the entire plugin tree to Vim 8 native packages (`pack/vendor/start/` and `pack/forked/start/`), leveraging Vim 8's built-in `+packages` feature.
  * Eliminated pathogen initialization overhead and runtime path scanning delays.

---

## 2. Autocommand `BufEnter` Fixes (`winnr('h')` & `E15`)
* **Problem**:
  * An upstream snippet from NERDTree's FAQ used:
    ```vim
    autocmd BufEnter * if winnr() == winnr('h') && ...
    ```
  * In **Vim 8.0** (before Patch 8.1.1140 released in April 2019), `winnr()` only accepted `'$'` (total window count) or `'#'` (previous window). Passing direction strings like `'h'`, `'j'`, `'k'`, `'l'` was not implemented.
  * When evaluated in Vim 8.0, the interpreter threw:
    ```text
    Error detected while processing BufEnter Auto Commands for "*":
    E15: Invalid expression: h
    ```
* **Fix**:
  * Implemented a dedicated compatibility function `s:PreventNERDTreeBufReplace()` in [`my_configs.vim`](file:///home/badppg/vimrc/my_configs.vim) and [`my_configs.vim.template`](file:///home/badppg/vimrc/my_configs.vim.template).
  * Safely determined tree position using universally supported expressions:
    ```vim
    let l:is_tree_win = (exists('g:NERDTreeWinPos') && g:NERDTreeWinPos ==# 'right') ? (winnr() == winnr('$')) : (winnr() == 1)
    ```
  * **Automatic Self-Healing for Existing Installations**:
    * Because `my_configs.vim` is untracked (in `.gitignore`), running `git pull` does not modify an already-existing local configuration file.
    * Added an automatic self-healing routine to tracked `vimrcs/extended.vim` and the install scripts: on startup, Vim automatically detects and replaces any legacy unpatched `winnr('h')` in local `my_configs.vim` with `1`, curing legacy errors transparently without manual intervention.

---

## 3. LeaderF MRU Unnamed Buffer Fix (`<afile>` & `E495`)
* **Problem**:
  * In `pack/vendor/start/LeaderF/plugin/leaderf.vim`, the MRU hook was registered as:
    ```vim
    autocmd BufEnter,BufWritePost * call lfMru#record(s:Normalize(expand('<afile>:p')))
    ```
  * When entering unnamed buffers (e.g. running `vim` without arguments, `:enew`, `Tagbar`, `Floaterm`, or help windows), `<afile>` does not exist on disk.
  * Vim 8.0 raised:
    ```text
    Error detected while processing BufEnter Auto Commands for "*":
    E495: No autocommand file name to substitute for "<afile>"
    ```
* **Fix**:
  * Switched the autocommand to pass `<abuf>` (which is always an integer ID):
    ```vim
    autocmd BufEnter,BufWritePost * call s:RecordMru(expand('<abuf>'))
    ```
  * In `s:RecordMru(abuf)`, resolved the buffer name via `bufname(str2nr(a:abuf))` and only recorded when non-empty and valid.

---

## 4. `cpoptions` Isolation & Broken Line Continuations (`E33`)
* **Problem**:
  * In `pack/vendor/start/ale/autoload/ale/events.vim` (`ale#events#ReadOrEnterEvent`), a multi-line `if` condition used line continuations:
    ```vim
    if get(g:, 'ale_pattern_options_enabled', 1)
    \&& !empty(get(g:, 'ale_pattern_options'))
    ```
  * If Vim starts with `cpoptions` containing the `C` flag (Vi compatibility), the backslash `\` is parsed as a regular command, and the following `&` is treated as a repeat substitute command, raising:
    ```text
    E33: No previous substitute regular expression
    ```
* **Fix**:
  * Added `let s:cpo_save = &cpo | set cpo&vim` and `let &cpo = s:cpo_save` guards across critical plugin files (ALE events, NERDCommenter).
  * Enforced `set nocompatible` followed by `set cpoptions&vim` at the entry point of `~/.vimrc`, `vimrcs/basic.vim`, and install scripts.
  * Flattened multi-line autocommand conditions into single-line statements.

---

## 5. SuperTab Integration & Version Pinning (v2.1)
* **Problem**:
  * Upstream `master` branch of `ervandew/supertab` requires Vim >= 9.0 (uses `has('patch-9.0.xxxx')` and modern Vimscript constructs), failing on Vim 8.0.
  * In `vimrcs/plugins_config.vim`, a legacy bug initialized `let g:snipMate = {}`, which wiped out snipMate's default runtime dictionary.
* **Fix**:
  * Pinned `ervandew/supertab` strictly to release **v2.1**, which provides full, rock-solid support for Vim 8.0.
  * Fixed snipMate dictionary initialization using `if !exists('g:snipMate') | let g:snipMate = {} | endif`.
  * Configured context-aware completion: expands snipMate snippets (e.g. `mod<Tab>`), completes paths after `/`, and performs buffer keyword completion (`<C-n>`) otherwise.

---

## 6. Terminal Emulation Fallback & BufLeave Fix (`vim-floaterm`)
* **Problem 1 (Popup vs Split)**:
  * Floating popups (`popupwin`) were introduced in Vim 8.1.1700+.
  * On Vim 8.0 (`8.0.1763`), `has('patch-8.1.1700')` is `0`, so floating window dimensions (`--width=0.8 --height=0.8`) cannot use popup APIs.
* **Problem 2 (`BufLeave` & `E119: Not enough arguments for function: bufnr`)**:
  * In `vim-floaterm`, `terminal.vim` registered an autocommand:
    ```vim
    autocmd BufLeave <buffer> call floaterm#window#record_cursor(bufnr())
    ```
  * In Vim 8.0, `bufnr()` requires at least one argument (e.g. `bufnr('%')`). Bram only made the argument optional in newer Vim versions.
  * When switching focus from the terminal to another buffer/window, Vim 8.0 threw:
    ```text
    Error detected while processing BufLeave Auto commands for "<buffer=3>":
    E119: Not enough arguments for function: bufnr
    ```
* **Fix**:
  * Leveraged `v8.0`'s native terminal channel support (`+terminal`).
  * Configured `vim-floaterm` with automatic fallback to split-window terminal when floating windows are unavailable, mapped to `F12` / `<leader>tt`.
  * Replaced `bufnr()` with backwards-compatible `bufnr('%')` in `pack/vendor/start/vim-floaterm/autoload/floaterm/terminal.vim`, resolving the `BufLeave` E119 error completely.

---

## 7. Remote VNC/SSH Performance (Lightline + Buftabline)
* **Problem**:
  * Heavy statusline plugins (like `vim-airline`) introduce noticeable latency and screen redraw lag over remote X11/VNC/SSH connections.
* **Fix**:
  * Kept `itchyny/lightline.vim` in asynchronous, passive mode (no background polling timers).
  * Added `ap/vim-buftabline` for buffer tabs displayed directly in the top tabline (`set stal=2`), eliminating the need to open heavy Vim tabs for single-file navigation.

---

## 8. gVim GUI Font Scaling for GTK3 / X11
* **Problem**:
  * In Linux GTK3 gVim (standard on RHEL 8), `guifont` format requires comma-delimited entries with `:h<size>` (e.g. `JetBrainsMonoNL\ Nerd\ Font\ 11` or `Hack\ 10:h10`).
* **Fix**:
  * Created `s:AdjustFontSize(amount)` supporting regex matching for `:h\d+` and trailing font size numbers.
  * Clamped font sizes safely between 8pt and 36pt.
  * Provided shortcuts `<leader>=`, `<leader>-`, `<C-ScrollWheelUp>`, and `<C-ScrollWheelDown>`.

---

## 9. Verilog / SystemVerilog Indent API Modernization
* **Problem**:
  * `vhda/verilog_systemverilog.vim` v3+ deprecated `g:verilog_disable_indent` in favor of `g:verilog_disable_indent_lst`.
* **Fix**:
  * Updated configuration to `let g:verilog_disable_indent_lst = "all"` in both `plugins_config.vim` and `my_configs.vim`.
  * Bound `autocmd FileType verilog,verilog_systemverilog,systemverilog setlocal indentexpr=` to ensure zero unexpected indentation shifts during port lists and always blocks.

---

## 10. Offline & Enterprise Cleanliness
* **Removed GitHub Copilot**:
  * `copilot.vim` requires Node.js >= 18 and Vim >= 9.0 / modern patchlevels, which is completely unusable in strictly offline, air-gapped IC design environments.
  * Cleanly uninstalled from runtime and plugin update lists.
* **Replaced `vim-commentary` with `nerdcommenter`**:
  * Added full support for block comments, sexy banner comments, and custom delimiters for Verilog/SV (`//`), TCL (`#`), Perl (`#`), and Python (`#`).
  * Fixed key mapping collision with legacy `cope` (`<leader>cc` freed for commenting; cope moved to `,cq`).
