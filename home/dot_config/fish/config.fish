# ~/.config/fish/config.fish

# Disable the welcome text.
function fish_greeting
end

#########################
# Environment variables #
#########################

## Editor
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx VIMCONFIG ~/.config/nvim
set -gx VIMDATA ~/.local/share/nvim

## Erlang shell history
set -gx ERL_AFLAGS "-kernel shell_history enabled"

## bat, a cat(1) clone -- https://github.com/sharkdp/bat
set -gx BAT_PAGER "less -RF"

## fd -- https://github.com/sharkdp/fd
set -gx FD_OPTIONS "--follow --exclude .git --exclude node_modules"

## fzf -- https://github.com/junegunn/fzf
set -gx FZF_DEFAULT_OPTS "
  --no-mouse
  --height 50% -1
  --reverse
  --multi
  --inline-info
  --preview='bat --style=numbers --color=always {} 2> /dev/null | head -500'
  --preview-window='right:wrap:hidden'"
set -gx FZF_DEFAULT_COMMAND "rg --files"
set -gx FZF_CTRL_T_COMMAND "fd $FD_OPTIONS"
set -gx FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS"

#########
# PATH  #
#########
# Global scope: recomputed on every launch, so it stays idempotent and
# doesn't fossilize into universal variables the way `fish_user_paths` does.
fish_add_path -g ~/.local/bin ~/.mix/escripts

########################
# Tool initialization  #
########################

## mise -- runtime/version manager (replaces asdf, pyenv, kerl)
command -q mise; and mise activate fish | source

## fzf key bindings & completion (fzf >= 0.48)
command -q fzf; and fzf --fish | source

## zoxide -- smarter cd. `z <dir>` jumps by frecency, `zi` picks with fzf.
command -q zoxide; and zoxide init fish | source

## atuin -- searchable shell history on Ctrl-R. Up arrow stays fish's own
## history; drop the flag to let atuin take it over too.
command -q atuin; and atuin init fish --disable-up-arrow | source

###########
# Aliases #
###########
# Git shortcuts as abbreviations: they expand inline, so you keep git's own
# completions and see the real command in history.
abbr -a ga git add
abbr -a gb git branch
abbr -a gc git commit
abbr -a gd git diff
abbr -a gco git checkout
abbr -a grm git rm
abbr -a gs git status
abbr -a gp git pull

abbr -a vim nvim

##########
# Prompt #
##########
## starship -- keep last so nothing else overrides fish_prompt.
command -q starship; and starship init fish | source
