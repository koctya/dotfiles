# Unix notes

### htop
htop is what top looks like after she puts on her dancing shoes on a Friday night
It's such an improvement over plain ole' top — with no known downsides — that I have an alias in my shell:

     if [[ -x `which htop` ]]; then alias top="htop"; fi

To install htop from repos:

   # Debian
   $ aptitude install htop
   # Arch
   $ pacman -S htop
   # OS X
   brew install htop-osx

### ack

ack is a text search tool akin to grep, but with some pretty distinct advantages:

- fast — it only searches what makes sense to search
- defaults to recursive searches
- defaults to colored output
- defaults to show line numbers of matched strings
- takes fewer keystrokes
- uses Perl's powerful regular expressions

Needless to say, it's better than grep.

To install ack from repos:

   # Debian
   $ aptitude install ack-grep
   $ ln -s /usr/bin/ack-grep /usr/bin/ack
   # Arch
   $ pacman -S ack
   # OS X
   $ brew install ack

### tree

tree is a great way to wrap your head around a directory structure instead of `cd`ing and `ls`ing all over the place.

The output can be a bit overwhelming for directories with many files and subdirectories, but it can be easily piped to `less` so you can page and navigate it.

To install tree from repos:

   # Debian
   $ aptitude install tree
   # Arch
   $ pacman -S tree
   # OS X
   $ brew install tree
