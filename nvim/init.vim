" turn off mouse
set mouse=""

let g:python_host_prog = '/Users/milmazz/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/milmazz/.pyenv/versions/neovim3/bin/python'

" Sane tabs
" - Two spaces wide
set tabstop=2
set softtabstop=2
" - Expand them all
set expandtab
" - Indent by 2 spaces by default
set shiftwidth=2

" set default encoding to UTF-8
set encoding=utf-8

" Use comma for leader
let g:mapleader=','

set number " line numbering

" Highlight search results
set hlsearch
" Incremental search, search as you type
set incsearch
" Ignore case when searching
set ignorecase smartcase
" Ignore case when searching lowercase
set smartcase
" Stop highlighting on Enter
map <CR> :nohlsearch<cr>

" Highlight cursor position
set cursorline
set cursorcolumn

" set the title of the iterm tab
set title

" Autoinstall vim-plug {{{
if empty(glob('~/.nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}

call plug#begin('~/.local/share/nvim/plugged')
  " asynchronous completation framework
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " Polyglot loads language support on demand!
  Plug 'sheerun/vim-polyglot'
  " Color theme
  Plug 'tomasr/molokai'
  Plug 'fmoralesc/molokayo'
  " add ANSI escape sequences
  " Plug 'powerman/vim-plugin-AnsiEsc'
  " Better statusbar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  " Tree navigation
  " NOTE: I think I'll not need this plugin anymore, project navigation with fzf is
  " way faster.
  "Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  " Intellisense engine, full language protocol server support
  " NOTE: I will try using ALE + Elixir Language Server instead
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " FZF
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  " Elixir configuration
  Plug 'elixir-editors/vim-elixir'
  " wisely "end" in Elixir and other languages
  Plug 'tpope/vim-endwise'
  " NOTE: Go to definition does not work now
  "Plug 'slashmili/alchemist.vim'
  " Git integration
  Plug 'tpope/vim-fugitive'
  " GitHub integration
  Plug 'tpope/vim-rhubarb'
  " Snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  " Execute code checks, find mistakes, in the background
  " NOTE: This works really well with credo, I'll try ALE + Elixir Language
  " Server for now.
  "Plug 'neomake/neomake'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'dense-analysis/ale'
  " Testing
  Plug 'janko/vim-test'
call plug#end()

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
" Use ALE as completion sources for all code.
call deoplete#custom#option('sources', {
\ '_': ['ale'],
\})
" use tab for completion
inoremap <expr><tab> pumvisible() ? '\<c-n>' : '\<tab>'
nnoremap <silent> <C-p> :FzfFiles<CR>
nnoremap <leader>g :FzfGFiles<CR>
nnoremap <leader>f :FzfFiles<CR>
nnoremap <leader>b :FzfBuffers<CR>
nnoremap <leader>h :FzfHistory<CR>
nnoremap <leader>? :FzfHelptags<CR>
nnoremap <leader>t :FzfTags<CR>
" }}}

" Git Integration with vim-fugitive {{{
" Fix broken syntax highlight in gitcommit files
" (https://github.com/tpope/vim-git/issues/12)
let g:fugitive_git_executable = 'LANG=en_US.UTF-8 git'

nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
"nnoremap <silent> <leader>gE :Gedit<space>
nnoremap <silent> <leader>gr :Gread<CR>
"nnoremap <silent> <leader>gR :Gread<space>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gW :Gwrite!<CR>
nnoremap <silent> <leader>gq :Gwq<CR>
nnoremap <silent> <leader>gQ :Gwq!<CR>

"function! ReviewLastCommit()
"  if exists('b:git_dir')
"    Gtabedit HEAD^{}
"    nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
"  else
"    echo 'No git a git repository:' expand('%:p')
"  endif
"endfunction
"nnoremap <silent> <leader>g` :call ReviewLastCommit()<CR>
" }}}

" Linting {{{
"augroup localneomake
"  autocmd! BufWritePost * Neomake
"augroup END
"" Don't warn me to use smartquotes in Markdown ok?
"let g:neomake_markdown_enabled_makers = []
"" Configure a nice credo setup, courtesy https://github.com/neomake/neomake/pull/300
"let g:neomake_elixir_enabled_makers = ['mix', 'mycredo']
"function NeomakeCredoErrorType(entry)
"  if a:entry.type ==# 'F'     " Refactoring opportunities
"    let type = 'W'
"  elseif a:entry.type ==# 'D' " Software design suggestions
"    let type = 'I'
"  elseif a:entry.type ==# 'W' " Warnings
"    let type = 'W'
"  elseif a:entry.type ==# 'R' " Readability suggestions
"    let type = 'I'
"  elseif a:entry.type ==# 'C' " Convention violation
"    let type = 'W'
"  else
"    let type = 'M'            " Everything else is a message
"  endif
"  let a:entry.type = type
"endfunction
"let g:neomake_elixir_mycredo_maker = {
"      \ 'exe': 'mix',
"      \ 'args': ['credo', 'list', '%:p', '--format=oneline'],
"      \ 'errorformat': '[%t] %. %f:%l:%c %m,[%t] %. %f:%l %m',
"      \ 'postprocess': function('NeomakeCredoErrorType')
"      \ }
" }}}

" Snippets {{{
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<c-b>'
let g:UltiSnipsJumpBackwardTrigger = '<c-z>'
" }}}

" Elixir {{{
" Jump to the definition
"let g:alchemist_tag_map = '<C-]>'
" Jump through tag stack
"let g:alchemist_tag_stack_map = '<C-T>'
" Source path for Elixir and Erlang
"let g:alchemist#elixir_erlang_src = '/usr/local/share/src'
" Set IEx terminal size
"let g:alchemist_iex_term_size = 15
" Set IEx window split
"let g:alchemist_iex_term_split = 'split'
" }}}

" Status Bar {{{
let g:airline_theme = 'luna'
let g:bufferline_echo = 0
let g:airline_powerline_fonts = 1
let g:airline_enable_branch = 1
let g:airline_enable_syntasti = 1
let g:airline_branch_prefix = '⎇ '
let g:airline_paste_symbol = '∥'
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#branch#displayed_head_limit = 17
" show errors or warnings in my statusline (ALE integration)
let g:airline#extensions#ale#enabled = 1
" }}}

" Fuzzy Finder{{{
let g:fzf_command_prefix = 'Fzf'
let g:fzf_action = {
 \ 'ctrl-t': 'tab-split',
 \ 'ctrl-x': 'split',
 \ 'ctrl-v': 'vsplit'}
" }}}

" ALE {{{
" Enable completion where available.
" " This setting must be set before ALE is loaded.
" "
" " You should not turn this setting on if you wish to use ALE as a completion
" " source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_linters_explicit = 1
" fix files when you save them.
let g:ale_fix_on_save = 1
" Do not run ALE on:
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'elixir': ['elixir-ls', 'credo'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'elixir': ['mix_format'],
\}
let g:ale_elixir_elixir_ls_release='/Users/milmazz/Dev/elixir-lang/elixir-ls/release'
autocmd FileType elixir nnoremap <leader>] :ALEGoToDefinition<CR>
"Move between linting errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}

" Testing {{{
let test#strategy = 'neovim'
let test#neovim#term_position = 'topleft'
" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
" }}}

set background=dark
" Activate Syntax Highlight
syntax enable
colorscheme molokai

" Highlight characters that overstep the 120 character limit
set colorcolumn=120

" Show the linebreak if wrapping is enabled
set showbreak=↪

" NOTE: This is also covered with ALE plugin.
" Delete trailing white space on save
"func! DeleteTrailingWS()
"  exe "normal mz"
"  %s/\s\+$//ge
"  exe "normal `z"
"endfunc
"autocmd BufWrite * silent call DeleteTrailingWS()

" Format Elixir files on save
"autocmd BufWritePost *.exs,*.ex silent :!mix format %

" NO ARROW KEYS COME ON
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>
