#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT
export HOME="$TEST_ROOT/home"
mkdir -p "$HOME/.dotfiles" "$HOME/.copilot/skills"
cp -R "$SCRIPT_DIR/.." "$HOME/.dotfiles/repo"
ZSH_EVAL_CONTEXT=""
source "$HOME/.dotfiles/repo/scripts/install.sh"
DOTFILES_ROOT="$HOME/.dotfiles/repo"

printf 'local settings\n' > "$HOME/.copilot/settings.json"
printf 'local skill\n' > "$HOME/.copilot/skills/local.md"
printf 'local state\n' > "$HOME/.copilot/config.json"
ln -s "$HOME/missing-agent-directory" "$HOME/.copilot/agents"

install_dotfiles

for entry in settings.json copilot-instructions.md instructions skills agents; do
  if [ ! -L "$HOME/.copilot/$entry" ] || [ ! -e "$HOME/.copilot/$entry" ]; then
    echo "FAIL: Copilot $entry must be linked to shared configuration" >&2
    exit 1
  fi
done

grep -qx 'local settings' "$HOME"/.copilot/backups/dotfiles.*/settings.json
grep -qx 'local skill' "$HOME"/.copilot/backups/dotfiles.*/skills/local.md
backed_up_agents=("$HOME"/.copilot/backups/dotfiles.*/agents)
[ "$(readlink "${backed_up_agents[0]}")" = "$HOME/missing-agent-directory" ]
[ ! -L "$HOME/.copilot/config.json" ]
grep -qx 'local state' "$HOME/.copilot/config.json"

backup_count="$(find "$HOME/.copilot/backups" -type d | wc -l)"
install_dotfiles
[ "$(find "$HOME/.copilot/backups" -type d | wc -l)" = "$backup_count" ]

printf 'shared skill\n' > "$HOME/.copilot/skills/shared.md"
grep -qx 'shared skill' "$DOTFILES_ROOT/copilot/skills/shared.md"
echo "PASS: Copilot links, backups, local state, and repeat installation"
