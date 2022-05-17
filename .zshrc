ZSH=$HOME/.oh-my-zsh

export EDITOR=vim
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

path_array=(
  "$(pyenv root)/shims:$PATH"
  "$HOME/.rbenv/bin:$PATH"
  "${HOME}/.goenv/bin:$PATH"
  "$HOME/.cargo/bin"
  "/usr/local/opt/"
  "/usr/local/bin"
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  "/usr/X11/bin"
)

export PATH=$(perl -le 'print join ":",@ARGV' "${path_array[@]}")


#######################
# Source Some Helpers #
#######################

command -v rbenv > /dev/null && eval "$(rbenv init -)"
command -v pyenv > /dev/null && eval "$(pyenv init -)"
command -v goenv > /dev/null && eval "$(goenv init -)"

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

if [[ -d  "$(brew --prefix)/Caskroom/google-cloud-sdk/" ]]; then
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

########################
# Local Customizations #
########################

test -f "${HOME}/.zshrc.local" && source "${HOME}/.zshrc.local"

