# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"

export EDITOR=vim

# Example aliases
 alias zshconfig="vim ~/.zshrc"
 alias ohmyzsh="vim ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

VIRTUAL_ENV_DISABLE_PROMPT=0

alias sublime='open -a "Sublime Text 2"'
alias kd='knife dwim'
#alias ls='ls -alt --color=auto'

function tunnel_to_vagrant_mongo(){
    pushd . &> /dev/null
    cd ~/infrastructure_services
    vagrant ssh evo
    popd &> /dev/null
}

function boot_vagrant() {
    pushd . &> /dev/null
    cd ~/infrastructure_services
    vagrant up
    vagrant status
    popd &> /dev/null
}

function stop_vagrant(){
    pushd . &> /dev/null
    cd ~/infrastructure_services
    vagrant halt
    vagrant status
    popd &> /dev/null
}

function search_evo(){
    echo  "EvO Sources"
    echo "------------"
    find ~/evo/evo -name "*.py" | xargs grep -inE "$1"
    echo
    echo  "EvO Tests"
    echo "----------"

    find ~/evo/tests -name "*.py" | xargs grep -inE "$1"
}

function parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function parse_venv(){
    if [[ -n "$VIRTUAL_ENV" ]]; then
        basename $VIRTUAL_ENV
    fi
}

function display_branch_and_env(){
    local DISP="$(parse_venv)|$(parse_git_branch)"

    python -c "
env, repo = '$DISP'.split('|')
if not env and not repo: exit()
d = {'begin': '%{$fg_bold[yellow]%}', 'end': '%{$reset_color%}'}
if not env: env = '{begin}no-venv{end}'.format(**d)
if not repo: repo = '{begin}no-repo{end}'.format(**d)

print '[{env}|{repo}]'.format(env=env, repo=repo)
"
}

function elasticsearch_health(){
local report
local health
local name
for i in {1..3}
do
    report=$(curl "s-search$i:9200/_cluster/health?pretty=true" --silent )
    health=$(echo $report | grep status | sed 's|.*: \"\(.*\)\",|\1|')
    name=$(echo $report | grep cluster_name | sed 's|.*: \"\(.*\)\",|\1|')
    echo "s-search$i: \"$name\" - $health"
done
}

function precmd(){
    TEMP_PROMPT="
[%{$fg_bold[green]%}%n@%m%{$reset_color%}][%{$fg[yellow]%}%~%{$reset_color%}]
$(display_branch_and_env)~> "
}

function uniq_search_evo(){
    echo '------------'
    echo  "EvO Sources"
    echo "------------"

    find ~/evo/evo -name "*.py" | xargs grep user | python -c "for m in __import__('sys').stdin: print m.split(':')[0]" | uniq

    echo '\n-----------'
    echo  "EvO Tests"
    echo "----------"
    find ~/evo/tests  -name "*.py" | xargs grep user | python -c "for m in __import__('sys').stdin: print m.split(':')[0]" | uniq
}

PROMPT='$TEMP_PROMPT'

# Customize to your needs...
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local/munki:/opt/local/bin:/opt/local/sbin:/Users/dant/mongo/bin:$PATH

# MacPorts Installer addition on 2012-06-13_at_11:48:27: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:~/mongo/bin:$PATH

bindkey '^r' history-incremental-pattern-search-backward
# Finished adapting your PATH environment variable for use with MacPorts.

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
