set nocompatible

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

" Use comma for leader
let g:mapleader=','

set number " line numbering

" Ignore case when searching
set ignorecase smartcase
" Ignore case when searching lowercase
set smartcase
" Stop highlighting on Enter
" NOTE: vim-sensible allows to do the same with <C-L>
map <CR> :nohlsearch<cr>

" Highlight cursor position
set cursorline
set cursorcolumn

" set the title of the iterm tab
set title

" Autoinstall vim-plug {{{
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}

call plug#begin('~/.local/share/nvim/plugged')
  Plug 'tpope/vim-sensible'
  " Polyglot loads language support on demand!
  Plug 'sheerun/vim-polyglot'
  " Color theme
  Plug 'iCyMind/NeoSolarized'
  " add ANSI escape sequences
  Plug 'powerman/vim-plugin-AnsiEsc'
  " Better statusbar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  " FZF
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " Elixir configuration
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'elixir-lsp/elixir-ls', { 'do': { -> g:ElixirLS.compile() } }
  " wisely "end" in Elixir and other languages
  Plug 'tpope/vim-endwise'
  " Add a bunch of bracket mappings
  Plug 'tpope/vim-unimpaired'
  " Git integration
  Plug 'tpope/vim-fugitive'
  " GitHub integration
  Plug 'tpope/vim-rhubarb'
  " Snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  " Execute code checks, find mistakes, in the background
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'dense-analysis/ale'
  " Testing
  Plug 'janko/vim-test'
  " TOC for GFM
  Plug 'mzlogin/vim-markdown-toc'
  " Vim plugin for interacting with databases
  Plug 'tpope/vim-dadbod'
  " TODO, HACK, FIXME,... comments
  Plug 'nvim-lua/plenary.nvim'
  Plug 'folke/todo-comments.nvim'
call plug#end()

" See: https://bernheisel.com/blog/vim-elixir-ls-plug/
let g:coc_global_extensions = ['coc-elixir', 'coc-diagnostic']

" ElixirLS {{{
let g:ElixirLS = {}
let ElixirLS.path = stdpath('config').'/plugged/elixir-ls'
let ElixirLS.lsp = ElixirLS.path.'/release/language_server.sh'
let ElixirLS.cmd = join([
        \ 'asdf install &&',
        \ 'mix do',
        \ 'local.hex --force --if-missing,',
        \ 'local.rebar --force,',
        \ 'deps.get,',
        \ 'compile,',
        \ 'elixir_ls.release'
        \ ], ' ')

function ElixirLS.on_stdout(_job_id, data, _event)
  let self.output[-1] .= a:data[0]
  call extend(self.output, a:data[1:])
endfunction

let ElixirLS.on_stderr = function(ElixirLS.on_stdout)

function ElixirLS.on_exit(_job_id, exitcode, _event)
  if a:exitcode[0] == 0
    echom '>>> ElixirLS compiled'
  else
    echoerr join(self.output, ' ')
    echoerr '>>> ElixirLS compilation failed'
  endif
endfunction

function ElixirLS.compile()
  let me = copy(g:ElixirLS)
  let me.output = ['']
  echom '>>> compiling ElixirLS'
  let me.id = jobstart('cd ' . me.path . ' && git pull && ' . me.cmd, me)
endfunction

" If you want to wait on the compilation only when running :PlugUpdate
" then have the post-update hook use this function instead:

" function ElixirLS.compile_sync()
"   echom '>>> compiling ElixirLS'
"   silent call system(g:ElixirLS.cmd)
"   echom '>>> ElixirLS compiled'
" endfunction
" }}}

" Then, update the Elixir language server
call coc#config('elixir', {
  \ 'command': g:ElixirLS.lsp,
  \ 'filetypes': ['elixir', 'eelixir']
  \})
call coc#config('elixir.pathToElixirLS', g:ElixirLS.lsp)

" COC {{{
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
"xmap <leader>f <Plug>(coc-format-selected)
"nmap <leader>f <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
nnoremap <leader>, :Format<CR>

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" }}}

" Deoplete {{{
"let g:deoplete#enable_at_startup = 1
"if !exists('g:deoplete#custom#var')
"  let g:deoplete#custom#var = {}
"endif
"" Use ALE as completion sources for all code.
"call deoplete#custom#option('sources', {
"\ '_': ['ale'],
"\})
" use tab for completion
"inoremap <expr><tab> pumvisible() ? '\<c-n>' : '\<tab>'
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

" Snippets {{{
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<c-b>'
let g:UltiSnipsJumpBackwardTrigger = '<c-z>'
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
"let g:airline#extensions#ale#enabled = 0
let g:airline#extensions#coc#enabled = 1
let g:airline#exteneions#coc#error_symbol = 'Error:'
let g:airline#exteneions#coc#warning_symbol = 'Warning:'
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'
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
let g:ale_completion_enabled = 0
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_linters_explicit = 1
let g:ale_set_ballons = 1
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
"nnoremap <leader>, :ALEFix<CR>
" }}}

" Testing {{{
let test#strategy = 'neovim'
let test#neovim#term_position = 'topleft'
nmap <silent> <leader>tt :TestNearest<CR> "Test This
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR> "Test All
nmap <silent> <leader>tl :TestLast<CR>
" }}}

set background=dark
set termguicolors

" NeoSolarized {{{
colorscheme NeoSolarized
" default value is "normal", Setting this option to "high" or "low" does use the
" same Solarized palette but simply shifts some values up or down in order to
" expand or compress the tonal range displayed.
let g:neosolarized_contrast = "high"

" Special characters such as trailing whitespace, tabs, newlines, when displayed
" using ":set list" can be set to one of three levels depending on your needs.
" Default value is "normal". Provide "high" and "low" options.
let g:neosolarized_visibility = "normal"

" I make vertSplitBar a transparent background color. If you like the origin solarized vertSplitBar
" style more, set this value to 0.
let g:neosolarized_vertSplitBgTrans = 1

" If you wish to enable/disable NeoSolarized from displaying bold, underlined or italicized
" typefaces, simply assign 1 or 0 to the appropriate variable. Default values:
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0
" }}}

" Highlight characters that overstep the 120 character limit
set colorcolumn=120

" Show the linebreak if wrapping is enabled
set showbreak=↪

" NO ARROW KEYS COME ON
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

" highlight _bad words_
if exists("g:loaded_badWords")
  finish
endif
let g:loaded_badWords = 1

highlight badWords cterm=bold ctermbg=Red ctermfg=White

fun! HighlightBadWords()
  let en=[ 'obvious', 'obviously', 'basic', 'basically', 'simply', 'of course', 'just', 'everyone knows', 'easy', 'easily', 'trivial', 'trivially' ]
  let es=[ 'evidentemente', 'simplemente', 'claramente', 'trivial', 'trivialmente' ]

  for lang in [ en, es ]
    let matcher='\c\<\(' . join(lang, '\|') . '\)\>'
    call matchadd('badWords', matcher)
  endfor
endfun

autocmd BufRead,BufNewFile *.md,*.txt,*.rst call HighlightBadWords()
autocmd InsertLeave *.md,*.txt,*.rst call HighlightBadWords()

" Gutentag 'halt on exit' issue
" See: https://github.com/ludovicchabant/vim-gutentags/issues/178#issuecomment-575693926
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root  = ['package.json', '.git', '.hg', '.svn']
let g:gutentags_cache_dir = expand('~/.gutentags_cache')
let g:gutentags_exclude_filetypes = ['gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']
let g:gutentags_ctags_exclude = [
\  '*.git', '*.svn', '*.hg',
\  'cache', 'build', 'dist', 'bin', 'node_modules', 'bower_components',
\  '_build', 'deps', '*.elixir_ls',
\  '*-lock.json',  '*.lock',
\  '*.min.*',
\  '*.bak',
\  '*.zip',
\  '*.pyc',
\  '*.class',
\  '*.sln',
\  '*.csproj', '*.csproj.user',
\  '*.tmp',
\  '*.cache',
\  '*.vscode',
\  '*.pdb',
\  '*.exe', '*.dll', '*.bin',
\  '*.mp3', '*.ogg', '*.flac',
\  '*.swp', '*.swo',
\  '.DS_Store', '*.plist',
\  '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.svg',
\  '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
\  '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', '*.xls',
\]

" See: https://github.com/folke/todo-comments.nvim
lua << EOF
  require("todo-comments").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
