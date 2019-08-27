ZSH=$HOME/.oh-my-zsh

export EDITOR=vim
export CPPFLAGS='-L/usr/local/lib -I/usr/local/include'
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export GOENV_ROOT="${HOME}/.goenv"

plugins=(git golang docker docker-compose brew terraform)

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

####################
# Helper Functions #
####################

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

function docker_port () {
  echo "$(docker-compose port $1 $2 | awk -F: '{print $2}')"
}

function uuidv4 () {
  echo -n $(uuidgen | tr 'A-Z' 'a-z')
}

function size () {
  du -k "$@" | sort -n | awk '
    function human(x) {
        s="kMGTEPYZ";
        while (x>=1000 && length(s)>1)
            {x/=1024; s=substr(s,2)}
        return int(x+0.5) substr(s,1,1)
    }
    {gsub(/^[0-9]+/, human($1)); print}'
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

export PATH=$HOME/.cargo/bin:/usr/local/opt/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="/opt/chefdk/bin:$PATH"
export PATH="/opt/git-plugins:$PATH"

export PATH="${HOME}/.goenv/bin:$PATH"
eval "$(goenv init -)"


#######################
# Source Some Helpers #
#######################

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

[ -f /Users/dant/.travis/travis.sh ] && source /Users/dant/.travis/travis.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/completion.zsh.inc'; fi


########################
# Local Customizations #
########################

test -f "${HOME}/.zshrc.local" && source "${HOME}/.zshrc.local"
