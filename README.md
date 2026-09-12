# dotfiles

milmazz's dotfiles, managed with [chezmoi](https://www.chezmoi.io).

## What's here

| Path | Target | What |
|------|--------|------|
| `home/dot_config/fish/` | `~/.config/fish/` | fish shell config, functions, abbreviations |
| `home/dot_config/nvim/`  | `~/.config/nvim/`  | Neovim (LazyVim) |
| `home/dot_config/bat/`   | `~/.config/bat/`   | `bat` config |
| `home/dot_psqlrc.tmpl`   | `~/.psqlrc`        | psql config (template) |
| `home/dot_Brewfile.tmpl` | `~/.Brewfile`      | Homebrew bundle (template) |

The repo uses a [`.chezmoiroot`](https://www.chezmoi.io/reference/special-files/chezmoiroot/)
of `home/`, so everything chezmoi manages lives under `home/` and repo-root files
(`README.md`, `LICENSE`) are left alone.

Runtimes/tools are managed with [`mise`](https://mise.jdx.dev) (not asdf/pyenv).

## Bootstrap a new machine

Install [Homebrew](https://brew.sh) first, then:

```sh
brew install chezmoi
chezmoi init --apply git@github.com:milmazz/dotfiles.git
```

`chezmoi init` asks once whether this is a **work** or **personal** machine and
stores the answer as `machine` in `~/.config/chezmoi/chezmoi.toml`. Templates
use it to render machine-specific bits (currently the personal-only block at the
bottom of the Brewfile). To change the answer later, run `chezmoi init` again.

`chezmoi apply` writes `~/.Brewfile` and then runs `brew bundle --global`
automatically (see `home/run_onchange_after_10-brew-bundle.sh.tmpl`), installing
everything in the Brewfile.

## Day-to-day

```sh
chezmoi edit ~/.config/fish/config.fish   # edit a managed file
chezmoi diff                              # preview what apply would change
chezmoi apply -v                          # apply changes to $HOME
chezmoi re-add                            # pull edits made directly in ~ back into the source
chezmoi cd                                # drop into the source repo
```

> Note: chezmoi copies files into `~` (they are not symlinks). After editing a
> file directly in `~`, run `chezmoi re-add` (or edit via `chezmoi edit`) to keep
> the source in sync.

## Notes

- fish plugins are declared in `fish_plugins` and managed with
  [fisher](https://github.com/jorgebucaran/fisher): `jethrokuan/z`
  (directory jumping) and `oh-my-fish/theme-bobthefish` (prompt). On a fresh
  machine, install fisher and run `fisher update` to restore them:

  ```fish
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
  fisher update
  ```
- On first `apply`, chezmoi removes the leftover Oh My Fish loader
  (`~/.config/fish/conf.d/omf.fish`); see `home/.chezmoiremove`.
