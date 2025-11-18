alias editalias="vim ~/dev-setup/.zshrc"
alias reload_zshrc="rm ~/.zshrc && ln ~/dev-setup/.zshrc ~/.zshrc && source ~/.zshrc"
alias v="vim"
alias e="emacs -nw"
alias ll="ls -alrth"
alias gaa="git add -A"
alias gs="git status"
alias grs="gr status"
alias gp="git pull"
alias gc="git checkout"
alias gcb="git switch -c"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gcamend="git commit --amend"
alias gb="git branch"
alias gl="git log"
alias glg="gl --graph --oneline --decorate"
alias gf="git fetch"
alias killnodes="ps aux | grep "node\s" | awk '{print $2}' | xargs kill -9"
alias anynodes="ps aux | grep [^-]node"
alias gd="git diff"
alias gdc="git diff --cached"
alias grh="git reset --hard"
alias gpr="gh pr create"
alias getdockerip=get_docker_container_ip
alias nrt="npm run test"
alias gbd=git_branch_delete_like
alias gsl=git_switch_like
alias glv="git log | vim -R -"

# load my custom functions
fpath=( ~/dev-setup/zsh_scripts "${fpath[@]}" )

for FILE in ~/dev-setup/zsh_scripts/*; do autoload -Uz "$FILE"; done

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# rbenv
# PATH="$HOME/.rbenv/shims:$PATH"

eval "$(starship init zsh)"

function git_branch_delete_like() {
  git for-each-ref --format='%(refname:strip=2)' refs/heads | \
  grep "$1" | \
  xargs -I % sh -c 'git branch -D %'
}

function git_switch_like() {
  LOCAL_BRANCH=$(git for-each-ref --format='%(refname:strip=2)' refs/heads | grep "$1")
  if [ -n "$LOCAL_BRANCH" ]
  then
    git switch $LOCAL_BRANCH
  else
    git for-each-ref --format='%(refname:strip=3)' refs/remotes/ | \
    grep "$1" | \
    xargs -I % sh -c 'git switch %'
  fi
}

function kill_by_name() {
  kill $(ps aux | grep $1 | awk '{print $2}')
}

function docker_logs() {
  docker logs $(docker ps -a | grep $1 | awk '{ print $1 }')
}

function scripts() {
  jq '.scripts' package.json
}

function ping8 () {
  ping 8.8.8.8
}

function findTree() {
  TREE_IGNORE=".git|.svn|node_modules|.idea|bower_components|coverage|.gradle|dist|build|target|.stack-work"
  tree -I ${TREE_IGNORE} -a -P "$1" --prune
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

complete -C /usr/local/bin/terraform terraform

export HISTSIZE=3000
export HISTFILESIZE=3000

# direnv
eval "$(direnv hook zsh)"

export AWS_DEFAULT_REGION=eu-west-2

# git-run (gr) autocompletion
. <(gr completion)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# intellij path
export PATH=$PATH:/Applications/IntelliJ\ IDEA.app/Contents/MacOS


. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh --disable-up-arrow)"

# bun completions
[ -s "/Users/gryff/.bun/_bun" ] && source "/Users/gryff/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOMEBREW_PREFIX/opt/postgresql@15/bin:$PATH"

# some docker stuff now colima is in the mix
mkdir -p ~/.docker/cli-plugins
ln -sfn "$HOMEBREW_PREFIX/opt/docker-buildx/bin/docker-buildx" ~/.docker/cli-plugins/docker-buildx
ln -sfn "$HOMEBREW_PREFIX/opt/docker-compose/bin/docker-compose" ~/.docker/cli-plugins/docker-compose

# pnpm
export PNPM_HOME="/Users/gryff/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

ZSHRC_DIR="$HOME/dev-setup"
if [ -f "$ZSHRC_DIR/.zshrc.local" ]; then
  source "$ZSHRC_DIR/.zshrc.local"
fi
