alias editalias="vim ~/.zshrc"
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
alias gpreen=~/dev-setup/zsh_scripts/git_preen.sh # TODO
alias glv="git log | vim -R -"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# rbenv
PATH="$HOME/.rbenv/shims:$PATH"

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

