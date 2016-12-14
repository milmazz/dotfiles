## Disable welcome text
set --erase fish_greeting

if not set --query EDITOR
  set --universal --export EDITOR vim
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

### Macports
if test -d /opt/local/bin
  add_to_fish_user_paths /opt/local/bin
end

if test -d /opt/local/sbin
  add_to_fish_user_paths /opt/local/sbin
end

### Heroku
if test -d /usr/local/heroku/bin
  add_to_fish_user_paths /usr/local/heroku/bin
end

### Elixir
if test -d ~/Development/elixir-lang/elixir/bin
  add_to_fish_user_paths ~/Development/elixir-lang/elixir/bin
end

### Postgres.app
if test -d /Applications/Postgres.app/Contents/Versions/latest/bin
  add_to_fish_user_paths /Applications/Postgres.app/Contents/Versions/latest/bin
end

### rbenv
if test -d ~/.rbenv/bin
  add_to_fish_user_paths ~/.rbenv/bin
end

if test -d /opt/local/share/man
  set MANPATH /opt/local/share/man $MANPATH
end

# Load rbenv automatically
status --is-interactive; and test -e ~/.rbenv/bin; and source (rbenv init -|psub)

## Git
function gfo
  git fetch origin
end

function gpom
  git push origin master
end

function gcm
  git checkout master
end

function gmom
  git merge origin master
end

function gs
  git status
end

function ga
  git add .
end

function gc
  git commit -v
end

function jekyll
  bundle exec jekyll serve --drafts --config _config.yml,_config_dev.yml
end

function vim
  nvim $argv
end
