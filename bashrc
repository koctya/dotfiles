source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/functions
source ~/.bash/config
#source /usr/local/git/contrib/completion/git-completion.bash


# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"  # This loads RVM into a shell session.

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
