ZSH=$HOME/.oh-my-zsh

export EDITOR=vim
export CPPFLAGS='-L/usr/local/lib -I/usr/local/include'
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"

plugins=(git zsh-syntax-highlighting vagrant sublime golang docker docker-compose brew brew-cask)

source $ZSH/oh-my-zsh.sh

unsetopt correct
unsetopt correct_all
bindkey '^r' history-incremental-pattern-search-backward

VIRTUAL_ENV_DISABLE_PROMPT=0

# Make the Git branch completion less insane
__git_files () {
    _wanted files expl 'local files' _files
}

###########
# Aliases #
###########

alias 'be'='chef exec'
alias 'dater'='date -r "$(date +%s)" +"%a, %b %d %Y %T %z"'
alias 'dockergeddon'='docker ps -aq | xargs docker kill ; docker ps -aq | xargs docker rm -f'

####################
# Helper Functions #
####################

function kp (){
  knife $* -c ~/.chef_PROD/knife.rb
}

function kps (){
  knife search node $* -c ~/.chef_PROD/knife.rb
}

function parse_git_branch() {
  local branch="$(git branch 2> /dev/null | awk '/\* / {print $2}')"
  test ! -z "$branch" && echo -n "%{$fg[yellow]%}<$branch>%{$reset_color%}"
}

function wip() {
  git add --all . && git commit -a -m 'wip'
}

function prune_branches() {
  git branch --merged | egrep -v '\*|master' | xargs git branch -D
}

function unfleet () {
  local nodes="$(fleetctl --endpoint $1 list-unit-files | grep "$2" | awk '{print $1}' | uniq)"
  echo nodes | xargs fleetctl --endpoint $1 stop
  echo nodes | xargs fleetctl --endpoint $1 destroy
}

function docker_port () {
  echo "$(docker-compose port $1 $2 | awk -F: '{print $2}')"
}

#############
# PS1 Setup #
#############

function precmd(){
    TEMP_PROMPT="
[%{$fg_bold[green]%}%~%{$reset_color%}]$(parse_git_branch)
~> "
}

PROMPT='$TEMP_PROMPT'

export FPATH="$FPATH:/opt/local/share/zsh/site-functions/"

######################
# Path Manipulation  #
######################

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$HOME/go/bin

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="/opt/chefdk/bin:$PATH"
export PATH="/opt/git-plugins:$PATH"


#######################
# Source Some Helpers #
#######################

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

[ -f /Users/dant/.travis/travis.sh ] && source /Users/dant/.travis/travis.sh

########################
# Local Customizations #
########################

test -f "${HOME}/.zshrc.local" && source "${HOME}/.zshrc.local"

