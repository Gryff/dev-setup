eval "$(/opt/homebrew/bin/brew shellenv)"

typeset -U path

[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH=$PATH:/Applications/IntelliJ\ IDEA.app/Contents/MacOS

. "$HOME/.atuin/bin/env"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOMEBREW_PREFIX/opt/postgresql@15/bin:$PATH"

export PNPM_HOME="/Users/gryff/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/.local/bin:$PATH"

# shims for non-interactive shells; .zshrc runs the full `mise activate`
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims)"
fi
