#!/bin/bash
#
# Install/update dotfiles symlinks.
# Can be run standalone or sourced by other scripts.
#

DOTFILES_ROOT="$HOME/.dotfiles"

link_file () {
  local src="$1" dest="$2"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    rm "$dest"
  fi
  ln -s "$src" "$dest"
  echo "  Linked $src → $dest"
}

install_copilot () {
  local entry src dest backup
  mkdir -p "$HOME/.copilot" || return 1

  for entry in settings.json copilot-instructions.md instructions skills agents; do
    src="$DOTFILES_ROOT/copilot/$entry"
    dest="$HOME/.copilot/$entry"
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      continue
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      mkdir -p "$HOME/.copilot/backups" || return 1
      backup="$(mktemp -d "$HOME/.copilot/backups/dotfiles.XXXXXX")" || return 1
      mv "$dest" "$backup/$entry" || return 1
      echo "  Backed up $dest → $backup/$entry"
    fi
    ln -s "$src" "$dest" || return 1
    echo "  Linked $src → $dest"
  done
}

install_dotfiles () {
  for source in $(find "$DOTFILES_ROOT" -maxdepth 2 -name \*.symlink); do
    dest="$HOME/.$(basename "${source%.*}")"
    link_file "$source" "$dest"
  done

  # Directory symlinks
  link_file "$DOTFILES_ROOT/bin" "$HOME/bin"
  link_file "$DOTFILES_ROOT/lldb" "$HOME/.lldb"

  # ~/.config/ symlinks (Starship, mise)
  mkdir -p "$HOME/.config" "$HOME/.config/mise"
  link_file "$DOTFILES_ROOT/starship/starship.toml.symlink" "$HOME/.config/starship.toml"
  link_file "$DOTFILES_ROOT/mise/config.toml.symlink" "$HOME/.config/mise/config.toml"

  install_copilot
}

# Run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ "${ZSH_EVAL_CONTEXT}" == "toplevel" ]]; then
  install_dotfiles
fi
