#!/usr/bin/env bash
#
# bootstrap.sh — set up a fresh machine from this repo.
# Safe to re-run: every step is idempotent.
#
#   ./bootstrap.sh          # do everything
#   ./bootstrap.sh brew     # only install Homebrew + packages
#   ./bootstrap.sh link     # only (re)link dotfiles
#   ./bootstrap.sh mise     # only install mise
#   ./bootstrap.sh atuin    # only install atuin
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Dotfiles in the repo root that get hard-linked into $HOME.
# Hard links (not symlinks) are deliberate — symlinks have caused problems.
# (zsh_scripts/ and .zshrc.local are referenced from the repo directly by
#  .zshrc, so they intentionally aren't linked here.)
DOTFILES=(.zshrc .zprofile .zshenv .vimrc .ideavimrc)

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew already installed."
  else
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # Load brew into this shell (the linked .zprofile handles future shells).
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_brew_packages() {
  install_homebrew
  log "Installing brew formulae..."
  brew install $(<"$REPO_DIR/brew-packages.txt")
  log "Installing brew casks..."
  brew install --cask $(<"$REPO_DIR/brew-cask-packages.txt")
}

install_mise() {
  if command -v mise >/dev/null 2>&1; then
    log "mise already installed."
  else
    log "Installing mise..."
    curl https://mise.run | sh
  fi
}

install_atuin() {
  if command -v atuin >/dev/null 2>&1; then
    log "atuin already installed."
  else
    log "Installing atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  fi
  # atuin's shell init lives in the linked .zshrc; nothing else to do here.
}

link_dotfiles() {
  log "Hard-linking dotfiles into $HOME..."
  local backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
  for f in "${DOTFILES[@]}"; do
    local src="$REPO_DIR/$f"
    local dest="$HOME/$f"
    [ -e "$src" ] || { log "  skip $f (missing in repo)"; continue; }

    # Already the same inode? Nothing to do.
    if [ "$dest" -ef "$src" ]; then
      log "  ok   $f"
      continue
    fi

    # Back up anything real that's in the way (copy, old link, etc.).
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      mkdir -p "$backup_dir"
      mv "$dest" "$backup_dir/$f"
      log "  moved existing $f -> $backup_dir/$f"
    fi

    ln "$src" "$dest"
    log "  link $f -> $src"
  done
}

main() {
  case "${1:-all}" in
    brew) install_brew_packages ;;
    mise) install_mise ;;
    atuin) install_atuin ;;
    link) link_dotfiles ;;
    all)
      install_brew_packages
      install_mise
      install_atuin
      link_dotfiles
      log "Done. Open a new shell (or 'source ~/.zshrc') to pick everything up."
      ;;
    *) echo "usage: $0 [all|brew|mise|atuin|link]" >&2; exit 1 ;;
  esac
}

main "$@"
