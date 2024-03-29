## Disable welcome text
set --erase fish_greeting

#########################
# Environment variables #
#########################

## Erlang history
set -g -x ERL_AFLAGS "-kernel shell_history enabled"

## KERL options for Erlang
set -g -x KERL_BUILD_DOCS yes
set -g -x KERL_CONFIGURE_OPTIONS "--disable-debug --without-javac --with-ssl=/opt/homebrew/opt/openssl@1.1"

## Default editor: nvim
if not set --query EDITOR
  set --universal --export EDITOR nvim
end

## fd options
## See: https://github.com/sharkdp/fd
set -gx FD_OPTIONS "--follow --exclude .git --exclude node_modules"

## fzf options
## See: https://github.com/junegunn/fzf
set -gx FZF_DEFAULT_OPTS "
  --no-mouse
  --height 50% -1
  --reverse
  --multi
  --inline-info
  --preview='bat --style=numbers --color=always {} 2> /dev/null | head -500'
  --preview-window='right:wrap:hidden'"
  #--bind='ctrl-s:toggle-preview,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-y:execute-silent(echo {+} | pbcopy)'"
## Use git-ls-files inside git repo, otherwise fd
#set -gx FZF_DEFAULT_COMMAND "git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
set -gx FZF_DEFAULT_COMMAND "rg --files"
set -gx FZF_CTRL_T_COMMAND "fd $FD_OPTIONS"
set -gx FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS"

## Use Neovim as "preferred editor"
set -gx VISUAL nvim
set -gx VIMCONFIG ~/.config/nvim
set -gx VIMDATA ~/.local/share/nvim

## bat, a cat clone
## See: https://github.com/sharkdp/bat
set -gx BAT_PAGER "less -RF"

###################################
# Useful functions for fish-shell #
###################################
function add_to_fish_user_paths --description "Prepends to your PATH via fish_user_paths"
  for path in $argv
    # Avoid duplicate entries
    if not contains $path in $fish_user_paths
      set --universal --export fish_user_paths $path $fish_user_paths
    end
  end
end

function removepath
    if set -l index (contains -i $argv[1] $PATH)
        set --erase --universal fish_user_paths[$index]
        #echo "Updated PATH: $PATH"
        #else
        #echo "$argv[1] not found in PATH: $PATH"
    end
end

# asdf - version manager
# See: https://github.com/asdf-vm/asdf
if test -d /opt/homebrew/opt/asdf
  source /opt/homebrew/opt/asdf/asdf.fish
end

# iTerm fish integration
if test -e {$HOME}/.iterm2_shell_integration.fish
  source {$HOME}/.iterm2_shell_integration.fish
end

# ssl
#if test -d /usr/local/opt/openssl/bin
#  add_to_fish_user_paths /usr/local/opt/openssl/bin
#end

# Load virtualenv automatically
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source
status is-interactive; and pyenv virtualenv-init - | source

###########
# Aliases #
###########

## Elixir
function re --description "Get help on an Elixir module or function"
  iex -e "require IEx.Helpers; IEx.Helpers.h($argv); :erlang.halt" | cat
end

function hdocs --wrap="mix hex.docs" --description "alias hdocs=mix hex.docs"
  mix hex.docs $argv
end

## Git
function ga --wrap="git add" --description "alias ga=git add"
  git add $argv
end

function gb --wrap="git branch" --description "alias gb=git branch"
  git branch $argv
end

function gc --wrap="git commit" --description "alias gc=git commit"
  git commit $argv
end

function gd --wrap="git diff" --description "alias gd=git diff"
  git diff $argv
end

#function go --wrap="git checkout" --description "alias go=git checkout"
#  git checkout $argv
#end

function grm --wrap="git rm" --description "alias grm=git rm"
  git rm $argv
end

function gs --wrap="git status" --description "alias gs=git status"
  git status $argv
end

function vim --wrap="nvim" --description "alias vim=nvim"
  nvim $argv
end

function kgrep --wrap="kubectl" --description "get pods"
  kubectl get pods -n backend | grep $argv | cut -f 1 -d " "
end

function kexec --wrap="kubectl" --description "kubectl exec"
  kubectl exec -i -t -n backend $argv -- /bin/bash
end

function to_rtf --wrap="pygmentize" --description "export to RTF"
  pygmentize -f rtf -O "style=friendly,fontface=Cascadia Code" "$argv" | pbcopy
end

# starship init fish | source
