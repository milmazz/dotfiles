# dotfiles

milmazz's dotfiles, managed with [chezmoi](https://www.chezmoi.io).

## What's here

| Path | Target | What |
|------|--------|------|
| `home/dot_config/fish/` | `~/.config/fish/` | fish shell config, functions, abbreviations |
| `home/dot_config/nvim/`  | `~/.config/nvim/`  | Neovim (LazyVim) |
| `home/dot_config/bat/`   | `~/.config/bat/`   | `bat` config |
| `home/dot_psqlrc.tmpl`   | `~/.psqlrc`        | psql config (template) |
| `home/dot_gitconfig.tmpl` | `~/.gitconfig`    | git config (template; machine extras in `~/.gitconfig-local`) |
| `home/private_dot_ssh/`  | `~/.ssh/config`    | ssh client config (template; hosts in `~/.ssh/config.local`, keys never managed) |
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

`chezmoi init` asks two questions once and stores the answers in
`~/.config/chezmoi/chezmoi.toml`:

- `machine`: **work** or **personal**. Selects the personal-only block at the
  bottom of the Brewfile.
- `sshSigningKey`: path to the SSH public key for signing git commits
  (default `~/.ssh/id_ed25519.pub`). Signing is enabled only if that file
  exists; register the same key on GitHub as a *signing* key.

To change an answer later, run `chezmoi init` again.

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

- Prompt is [starship](https://starship.rs), directory jumping is
  [zoxide](https://github.com/ajeetdsouza/zoxide) (`z`, `zi`) and history is
  [atuin](https://atuin.sh) (Ctrl-R). All three come from the Brewfile and are
  initialized in `config.fish`. atuin is local-only until you opt in to sync
  (`atuin register` / `atuin login`); import old history with `atuin import auto`.
- fish plugins are declared in `fish_plugins` and managed with
  [fisher](https://github.com/jorgebucaran/fisher). On a fresh machine, install
  fisher and run `fisher update` to sync with that list (it also removes plugins
  no longer listed):

  ```fish
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
  fisher update
  ```
- On first `apply`, chezmoi removes the leftover Oh My Fish loader
  (`~/.config/fish/conf.d/omf.fish`); see `home/.chezmoiremove`.
