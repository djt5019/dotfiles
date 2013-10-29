# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"

export EDITOR=vim
export GOPATH=/usr/bin/go
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

alias kd='knife dwim'
alias kp='knife -c ~/.chef_PROD/knife.rb'
alias ack='~/bin/ack'
 
function knifeprod(){
  knife "$@" -c ~/.chef_PROD/knife.rb
}

function kp_search(){
  knife search node "$@" -c ~/.chef_PROD/knife.rb
}

alias kp='knifeprod'
alias kps='kp_search'

function parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function precmd(){
    TEMP_PROMPT="
[%{$fg_bold[green]%}%n@%m%{$reset_color%}][%{$fg[yellow]%}%~%{$reset_color%}]<$(parse_git_branch)>
~> "
}

PROMPT='$TEMP_PROMPT'

# Customize to your needs...
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local/munki:/opt/local/bin:/opt/local/sbin:/Users/dant/mongo/bin/:/Users/dant/redis/src/:$PATH

# MacPorts Installer addition on 2012-06-13_at_11:48:27: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:~/mongo/bin:$PATH

# Ad pg_prove
PATH=/opt/local/libexec/perl5.12/sitebin:$PATH

# Add RVM Crap
PATH=$HOME/.rvm/gems/ruby-1.9.3-p448/bin:$PATH # Add RVM to PATH for scripting

bindkey '^r' history-incremental-pattern-search-backward
# Finished adapting your PATH environment variable for use with MacPorts.

rvm use ruby-1.9.3 > /dev/null

unsetopt correct
unsetopt correct_all

export FPATH="$FPATH:/opt/local/share/zsh/site-functions/"
if [ -f /opt/local/etc/profile.d/autojump.zsh ]; then
    . /opt/local/etc/profile.d/autojump.zsh
fi

_rake_does_task_list_need_generating () {
  if [ ! -f .rake_tasks ]; then return 0;
  else
    accurate=$(stat -f%m .rake_tasks)
    changed=$(stat -f%m Rakefile)
    return $(expr $accurate '>=' $changed)
  fi
}

_rake () {
  if [ -f Rakefile ]; then
    if _rake_does_task_list_need_generating; then
      echo "\nGenerating .rake_tasks..." > /dev/stderr
      rake --silent --tasks | cut -d " " -f 2 > .rake_tasks
    fi
    compadd `cat .rake_tasks`
  fi
}

compdef _rake rake

alias devpi-ctl='/Users/dant/.devpi/bin/devpi-ctl'
plugins=(zsh-syntax-highlighting)
