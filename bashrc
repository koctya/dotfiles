source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/functions
source ~/.bash/config
#source /usr/local/git/contrib/completion/git-completion.bash


# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

[[ -s "/Users/kal/.rvm/scripts/rvm" ]] && source "/Users/kal/.rvm/scripts/rvm"  # This loads RVM into a shell session.
