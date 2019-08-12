## Disable welcome text
set --erase fish_greeting

## Erlang history
set -g -x ERL_AFLAGS "-kernel shell_history enabled"

if not set --query EDITOR
  set --universal --export EDITOR nvim
end

## Paths
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
        echo "Updated PATH: $PATH"
    else
        echo "$argv[1] not found in PATH: $PATH"
    end
end

## YARN
if test -d ~/.yarn/bin
  add_to_fish_user_paths ~/.yarn/bin
end

# asdf
if test -d /usr/local/opt/asdf/asdf
  source /usr/local/opt/asdf/asdf.fish
end

# ssl
if test -d /usr/local/opt/openssl/bin
  add_to_fish_user_paths /usr/local/opt/openssl/bin
end

### rbenv
if test -d ~/.rbenv/bin
  add_to_fish_user_paths ~/.rbenv/bin
end

# Virtualfish
#python -m virtualfish | source

# Load rbenv and virtualenv automatically
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source
#status --is-interactive; and rbenv init - | source

# Fzf + fd + bat
set -gx FD_OPTIONS "--follow --exclude .git --exclude node_modules"
set -gx FZF_DEFAULT_OPTS "
  --no-mouse
  --height 50% -1
  --reverse
  --multi
  --inline-info
  --preview='bat --style=numbers --color=always {} 2> /dev/null | head -500'
  --preview-window='right:wrap:hidden'
  --bind='ctrl-t:toggle-preview,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-y:execute-silent(echo {+} | pbcopy)'"
# Use git-ls-files inside git repo, otherwise fd
set -gx FZF_DEFAULT_COMMAND "git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
set -gx FZF_CTRL_T_COMMAND "fd $FD_OPTIONS"
set -gx FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS"
set -gx BAT_PAGER "less -RF"

# Aliases
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

function go --wrap="git checkout" --description "alias go=git checkout"
  git checkout $argv
end

function grm --wrap="git rm" --description "alias grm=git rm"
  git rm $argv
end

function gs --wrap="git status" --description "alias gs=git status"
  git status $argv
end

function vim --wrap="nvim" --description "alias vim=nvim"
  nvim $argv
end

function re --description "Get help on an Elixir module or function"
  iex -e "require IEx.Helpers; IEx.Helpers.h($argv); :erlang.halt" | cat
end
