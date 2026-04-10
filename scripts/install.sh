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
}

# Run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ "${ZSH_EVAL_CONTEXT}" == "toplevel" ]]; then
  install_dotfiles
fi
