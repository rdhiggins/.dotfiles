#!/bin/zsh
#
# Check if dotfiles are up-to-date with the remote (once per day).
# Sources from .zshrc. Prompts the user to pull if behind.
#

_dotfiles_update_check() {
  local dotdir="$HOME/.dotfiles"
  local stamp="$HOME/.cache/dotfiles-last-check"
  local interval=86400  # 24 hours in seconds

  # Ensure cache directory exists
  [[ -d "$HOME/.cache" ]] || mkdir -p "$HOME/.cache"

  # Skip if checked within the last 24 hours
  if [[ -f "$stamp" ]]; then
    local last_check=$(cat "$stamp")
    local now=$(date +%s)
    if (( now - last_check < interval )); then
      return
    fi
  fi

  # Record this check
  date +%s > "$stamp"

  # Bail if not a git repo or no remote configured
  if ! git -C "$dotdir" rev-parse --git-dir &>/dev/null; then
    return
  fi
  if ! git -C "$dotdir" remote get-url origin &>/dev/null; then
    return
  fi

  # Fetch quietly in background, wait with a timeout
  git -C "$dotdir" fetch --quiet origin &>/dev/null &
  local fetch_pid=$!

  # Wait up to 5 seconds for fetch to complete
  local waited=0
  while kill -0 "$fetch_pid" 2>/dev/null && (( waited < 5 )); do
    sleep 1
    (( waited++ ))
  done

  # If fetch is still running, skip this check
  if kill -0 "$fetch_pid" 2>/dev/null; then
    kill "$fetch_pid" 2>/dev/null
    return
  fi

  # Compare local and remote
  local local_head=$(git -C "$dotdir" rev-parse HEAD 2>/dev/null)
  local remote_head=$(git -C "$dotdir" rev-parse @{u} 2>/dev/null)

  if [[ -z "$remote_head" || "$local_head" == "$remote_head" ]]; then
    return
  fi

  # Check if local is behind remote
  local behind=$(git -C "$dotdir" rev-list --count HEAD..@{u} 2>/dev/null)
  if [[ "$behind" -gt 0 ]]; then
    echo ""
    echo "\033[1;33m⚡ Dotfiles are $behind commit(s) behind origin.\033[0m"

    local ahead=$(git -C "$dotdir" rev-list --count @{u}..HEAD 2>/dev/null)
    if [[ "$ahead" -gt 0 ]]; then
      echo "   (also $ahead local commit(s) not pushed)"
    fi

    echo -n "   Pull latest? [y/N] "
    if read -q; then
      echo ""
      git -C "$dotdir" pull --rebase --quiet origin && \
        echo "\033[1;32m   ✓ Dotfiles updated.\033[0m" || \
        echo "\033[1;31m   ✗ Pull failed. Run 'cd ~/.dotfiles && git pull' manually.\033[0m"
    else
      echo ""
      echo "   Skipped. Run \033[1mdot\033[0m to update manually."
    fi
  fi
}

_dotfiles_update_check
unfunction _dotfiles_update_check
