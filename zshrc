# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

SYSTEM=`uname -s`

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bundler rvm)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# . ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion

source ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc

[[ -s "/Users/kal/.rvm/scripts/rvm" ]] && source "/Users/kal/.rvm/scripts/rvm" # This loads RVM into a shell session.

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
