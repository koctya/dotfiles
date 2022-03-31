# ~/.bash_profile: executed by bash for login shells.

if [ -e ~/.bashrc ] ; then
  . ~/.bashrc
fi

if [ -e /Users/klandrus/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/klandrus/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
