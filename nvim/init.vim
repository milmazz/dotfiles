" turn off mouse
set mouse=""

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
" Double backslash for local leader - FIXME: Is this useful at all?
let g:maplocalleader='\\'

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

call plug#begin('~/.config/nvim/plugged')

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1
    if !exists('g:deoplete#omni#input_patterns')
      let g:deoplete#omni#input_patterns = {}
    endif
    " use tab for completion
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

  " Polyglot loads language support on demand!
  Plug 'sheerun/vim-polyglot'

  " Color theme
  " Plug 'altercation/vim-colors-solarized'
  Plug 'tomasr/molokai'
  Plug 'fmoralesc/molokayo'
  " add ANSI escape sequences
  " Plug 'powerman/vim-plugin-AnsiEsc'

  " Better statusbar
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
    let g:airline_theme = 'luna'
    let g:bufferline_echo = 0
    let g:airline_powerline_fonts=1
    let g:airline_enable_branch=1
    let g:airline_enable_syntastic=1
    let g:airline_branch_prefix = '⎇ '
    let g:airline_paste_symbol = '∥'
    let g:airline#extensions#tabline#enabled = 0
    let g:airline#extensions#branch#displayed_head_limit = 17

  " Execute code checks, find mistakes, in the background
  Plug 'neomake/neomake'
    " Run Neomake when I save any buffer
    augroup localneomake
      autocmd! BufWritePost * Neomake
    augroup END
    " Don't warn me to use smartquotes in Markdown ok?
    let g:neomake_markdown_enabled_makers = []
    " Configure a nice credo setup, courtesy https://github.com/neomake/neomake/pull/300
    let g:neomake_elixir_enabled_makers = ['mix', 'mycredo']
    function NeomakeCredoErrorType(entry)
      if a:entry.type ==# 'F'     " Refactoring opportunities
        let type = 'W'
      elseif a:entry.type ==# 'D' " Software design suggestions
        let type = 'I'
      elseif a:entry.type ==# 'W' " Warnings
        let type = 'W'
      elseif a:entry.type ==# 'R' " Readability suggestions
        let type = 'I'
      elseif a:entry.type ==# 'C' " Convention violation
        let type = 'W'
      else
        let type = 'M'            " Everything else is a message
      endif
      let a:entry.type = type
    endfunction
    let g:neomake_elixir_mycredo_maker = {
          \ 'exe': 'mix',
          \ 'args': ['credo', 'list', '%:p', '--format=oneline'],
          \ 'errorformat': '[%t] %. %f:%l:%c %m,[%t] %. %f:%l %m',
          \ 'postprocess': function('NeomakeCredoErrorType')
          \ }

  " Elixir
  Plug 'slashmili/alchemist.vim'

  " Phoenix
  Plug 'c-brenn/phoenix.vim'
  Plug 'tpope/vim-projectionist'

  " EditorConfig support
  Plug 'editorconfig/editorconfig-vim'
call plug#end()

" This must be after the plug section
set background=dark
" Activate Syntax Highlight
syntax enable
colorscheme molokai

" Highlight characters that overstep the 120 character limit
set colorcolumn=120

" Show the linebreak if wrapping is enabled
set showbreak=↪

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
au BufWrite * silent call DeleteTrailingWS()
