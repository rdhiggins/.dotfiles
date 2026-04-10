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

### Key tools installed via Brew

| Tool | Replaces | Purpose |
|------|----------|---------|
| `bat` | `cat` | Syntax-highlighted file viewer |
| `eza` | `ls` | Modern file listing with git status |
| `fd` | `find` | Fast file finder |
| `fzf` | — | Fuzzy finder for files, history, etc. |
| `git-delta` | `diff` | Side-by-side git diffs with syntax highlighting |
| `ripgrep` | `grep`/`ack` | Extremely fast recursive search |
| `zoxide` | `autojump`/`cd` | Smart directory jumping (`z <partial>`) |

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
| `pry/` | Ruby Pry REPL config |
| `rails/` | Rails application template |
| `scripts/` | Install/setup scripts |
| `zsh/` | Zsh config, prompt, and completions |

## Shell

Primary shell is **Zsh** with [Oh My Zsh](https://ohmyz.sh/).
Machine-specific secrets go in `~/.localrc` (not tracked).

## Copilot CLI Aliases

| Alias | Command |
|-------|---------|
| `ghcp` | `copilot` |
| `ghcpy` | `copilot --yolo` (auto-approve) |
| `ghcpr` | `copilot --continue` (resume session) |