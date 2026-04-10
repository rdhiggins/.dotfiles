# dotfiles

My dotfiles for macOS, managed with symlinks.

## Install

```bash
git clone https://github.com/rdhiggins/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
```

The install script finds all `*.symlink` files and creates symlinks in `$HOME`
(e.g., `zsh/zshrc.symlink` → `~/.zshrc`). It also links `bin/` → `~/bin` and
`lldb/` → `~/.lldb`.

## Dependencies

Install [Homebrew](https://brew.sh), then:

```bash
brew bundle --file=~/.Brewfile
```

## Structure

| Directory | Purpose |
|-----------|---------|
| `bash/` | Legacy bash configs (`.bashrc`, `.bash_profile`) |
| `bin/` | Custom scripts (symlinked to `~/bin`) |
| `brew/` | Homebrew Brewfile |
| `cfg/` | Shared aliases and environment variables |
| `gist/` | Ack search config |
| `git/` | Git config and global gitignore |
| `lldb/` | LLDB debugger scripts (symlinked to `~/.lldb`) |
| `mise/` | mise version manager config (symlinked to `~/.config/mise/config.toml`) |
| `pry/` | Ruby Pry REPL config |
| `rails/` | Rails application template |
| `scripts/` | Install/setup scripts |
| `starship/` | Starship prompt config (symlinked to `~/.config/starship.toml`) |
| `zsh/` | Zsh config and completions |

## Shell

Primary shell is **Zsh** with [Oh My Zsh](https://ohmyz.sh/).
Machine-specific secrets go in `~/.localrc` (not tracked).

## Prompt — Starship

The prompt is powered by [Starship](https://starship.rs/), a fast cross-shell
prompt written in Rust. The configuration lives in
`starship/starship.toml.symlink` and is symlinked to `~/.config/starship.toml`
so it is **shared across machines** via the dotfiles repo.

The prompt layout is two lines:

```
rdhiggins@mac ~/.dotfiles
14:30:00 on  main *⇡1 via 💎 3.2.0 via 🐍 3.13 took 3s
$
```

**Line 1:** user@host and current directory (yellow).
**Line 2:** time (cyan), git branch + status (red), language versions shown
automatically when relevant files are present, and elapsed time for slow
commands (>2s). The `$` prompt turns red after a failed command.

To customize, edit `starship/starship.toml.symlink` — changes are shared to
every machine that pulls the dotfiles. See the
[Starship config reference](https://starship.rs/config/) for all options.

## Automatic Update Check

Each time a new shell starts, the dotfiles repo is checked against origin — at
most **once every 24 hours**. If the local repo is behind, you'll see:

```
⚡ Dotfiles are 2 commit(s) behind origin.
   Pull latest? [y/N]
```

Press **y** to pull, or **N** to skip until the next day. The check runs a
`git fetch` with a 5-second timeout so it won't block shell startup on slow
connections. The last-check timestamp is stored in
`~/.cache/dotfiles-last-check`.

To update manually at any time, run `dot` — it pulls dotfiles and updates
Homebrew.

## Modern CLI Tools

The Brewfile installs modern replacements for common Unix tools. These are
wired up as shell aliases that fall back to the originals when not installed.

| Tool | Replaces | Purpose |
|------|----------|---------|
| [`bat`](https://github.com/sharkdp/bat) | `cat` | Syntax-highlighted file viewer |
| [`eza`](https://github.com/eza-community/eza) | `ls` | Modern file listing with git status and icons |
| [`fd`](https://github.com/sharkdp/fd) | `find` | Fast, user-friendly file finder |
| [`fzf`](https://github.com/junegunn/fzf) | — | Fuzzy finder for files, history (`Ctrl-R`), and more |
| [`git-delta`](https://github.com/dandavison/delta) | `diff` | Side-by-side git diffs with syntax highlighting |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) | `grep`/`ack` | Extremely fast recursive code search |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | `autojump`/`cd` | Smart directory jumping — `z <partial-path>` |

### Aliases provided

When `eza` is installed, these aliases are active:

| Alias | Expands to |
|-------|------------|
| `ls` | `eza` |
| `dir` / `ll` | `eza -la --git --icons` |
| `lt` | `eza -la --tree --level=2 --icons` |

When `bat` is installed:

| Alias | Expands to |
|-------|------------|
| `cat` | `bat --paging=never` |
| `catp` | `bat` (with paging) |

If neither tool is installed, `dir` and `cat` behave normally.

## Zsh Completions

Custom completions live in `zsh/completions/` and are loaded via `fpath`.

### GitHub Copilot CLI

Tab completions are included for the `copilot` command. Type `copilot <Tab>` to
see subcommands (`help`, `init`, `login`, `mcp`, `plugin`, `update`, `version`)
and `copilot --<Tab>` for all flags (`--model`, `--yolo`, `--continue`, etc.).

## Git Configuration

The git config (`git/gitconfig.symlink`) includes:

- **Editor:** Sublime Text (`subl -w`)
- **Pager:** [delta](https://github.com/dandavison/delta) with side-by-side diffs and line numbers
- **Merge conflicts:** `zdiff3` style (shows base, ours, theirs)
- **Pull strategy:** rebase (no merge commits)
- **Push:** `autoSetupRemote` — first push automatically sets upstream
- **Default branch:** `main`
- **Diff/merge tool:** Kaleidoscope
- **Credential helper:** macOS Keychain
- **Git LFS** enabled

## GitHub Copilot CLI

| Alias | Command | Description |
|-------|---------|-------------|
| `ghcp` | `copilot` | Start interactive session |
| `ghcpy` | `copilot --yolo` | Auto-approve all tool actions |
| `ghcpr` | `copilot --continue` | Resume most recent session |

> **Note:** Earlier versions used `cp`/`cpy`/`cpr` which shadowed the Unix `cp`
> command. The aliases were renamed to `ghcp`/`ghcpy`/`ghcpr` for safety.

## Language Version Manager — mise

[mise](https://mise.jdx.dev/) manages Ruby, Python, Node, and other language
runtimes in a single tool (replaces `rbenv`, `pyenv`, `nvm`).

```bash
mise use --global ruby@3.3       # set global Ruby version
mise use --global python@3.13    # set global Python version
mise use node@22                 # pin Node for the current project
mise ls                          # list installed versions
mise install                     # install versions from .mise.toml
```

Per-project versions are configured via `.mise.toml` (or `.tool-versions`)
and activate automatically when you `cd` into the directory. Global defaults
live in `~/.config/mise/config.toml`.

## Notable Aliases

See `cfg/aliases` for the full list. Highlights:

| Alias | Purpose |
|-------|---------|
| `to.<name>` | Quick `cd` to workspace directories (`to.ios`, `to.swift`, `to.dot`, etc.) |
| `buou` | `brew update && brew outdated && brew upgrade && brew cleanup` |
| `brew.backup` | Dump current Brewfile |
| `brew.restore` | Install from Brewfile |
| `reload` | Re-source `~/.zshrc` |
| `dotup` | Force dotfiles update check (bypasses 24hr cooldown) |
| `edot` | Open dotfiles in Sublime Text |
| `xc_clean` | Flush Xcode caches and DerivedData |
| `dump.ident` | List code signing identities |
| `fc.chi` | Weather for Chicago via wttr.in |
| `fdir` | `find . -type d -name` (renamed from `fd` to avoid conflict) |
| `ff` | `find . -type f -name` |
| `mdc <dir>` | `mkdir -p` and `cd` into it |
| `popcommands` | Show most-used commands from shell history |