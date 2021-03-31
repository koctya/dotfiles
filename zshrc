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
plugins=(git bundler)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"

ulimit -n 10000

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519   

. ~/.zsh/config
. ~/.zsh/aliases
# . ~/.zsh/completion

#source ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc

# Customize to your needs...
#export PATH=$PATH:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
export PATH=$PATH:$GOPATH/bin

### Added by the Heroku Toolbelt
#export PATH="/usr/local/heroku/bin:$PATH"

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

export PATH="$PATH:/usr/local/mysql/bin"

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export path=($path /Applications/Postgres.app/Contents/Versions/latest/bin )

### Added by IBM Cloud CLI
source /usr/local/Bluemix/bx/zsh_autocomplete
if [ -e /Users/klandrus/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/klandrus/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
