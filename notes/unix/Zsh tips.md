# Zsh tips

## Use [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

Simple. Head over to oh-my-zsh and follow the intructions. When installing Zsh, you should customize two things.

1. Themes
1. the plugins

    Oh-my-Zsh has a lot of great plugins. You can read more about them there. I found it easiest to just read through the simple source code of the ones that interested me. These are the ones that I use (from my ~/.zshrc file):

        plugins=(git mercurial autojump command-not-found python pip github gnu-utils history-substring-search)

    To use autojump on Ubuntu, you need to sudo apt-get install autojump. That enables you to just write j [directory] and it will jump to the most frequently used directory with that name. A great way to navigate, which naturally can use tab-completion. It just takes some time for your fingers to get used to it. Autojump is not limited to Zsh, of course.

## So what makes Zsh so great?

- Powerful context based tab completion

    File based tab completion is great and all, but zsh has tab completion for everything. It has knowledge about an impressive number of tools and scripts. It knows which commands git takes, which hosts are in my hosts file for ssh, which users my system have when I write chmod, available packages to apt-get, etc. Using [tab] when writing commands is a bit like static type checking, since if you don’t get a completion you are probably writing your argument type in the wrong place.
-   Pattern matching/globbing on alien steroids

    Globbing means command line parameter expansion. For example ls *.html. Zsh has it’s own globbing language. You can sort and filter by exclusion or inclusion on name, size, permission, owner, creation time. Everything.

        ls *(.)            # list just regular files
        ls *(/)            # list just directories
        ls -ld *(/om[1,3]) # Show three newest directories. "om" orders by modification. "[1,3]" works like Python slice.
        rm -i *(.L0)       # Remove zero length files, prompt for each file
        ls *(^m0)          # Files not modified today.
        emacs **/main.py   # Edit main.py, wherever it is in this directory tree. ** is great.
        ls **/*(.x)        # List all executable files in this tree
        ls *~*.*(.)        # List all files that does not have a dot in the filename
        ls -l */**(Lk+100) # List all files larger than 100kb in this tree
        ls DATA_[0-9](#c4,7).csv # List DATA_nnnn.csv to DATA_nnnnnnn.csv

    These examples happily borrowed from [Zzappers Best of ZSH Tips](http://www.rayninfo.co.uk/tips/zshtips.html), [Z shell made easy](http://www.tuxradar.com/content/z-shell-made-easy) and [Zsh-lovers man page](http://grml.org/zsh/zsh-lovers.html). Skim through them all, when you have decided to give Zsh a try.
-   Themeable prompts - see [Theme gallery](https://github.com/robbyrussell/oh-my-zsh/wiki/themes)
-   Loadable modules

    Loadable modules are modules that give your shell additional functionality. Sort of like importing a library when you code. They can make the filters above even more interesting. For example expressing date constraints in a natural format. There are examples of using modules in the Zsh-lovers man page and full documentation in the [Zsh Modules Documentation](http://www.math.technion.ac.il/Site/computing/docs/zsh/zsh_21.html).
-   Good spelling correction

    Zsh does not care if I write a filename in lowercase or mixed or whatever. When I try [tab] it will first try to complete on the exact match and then use a case insensitive match. Great! It also has spelling correction built-in in other places, suggesting which command you might have meant, etc
-   Sharing of command history among all running shells (I like my command line history and all my Konsole tabs)
-   Global aliases

    Aliases are nice, but global aliases are words that can be used anywhere on the command line, thus you can give certain files, filters or pipes a short name. Some examples:

        alias -g L="|less" # Write L after a command to page through the output.
        alias -g TL='| tail -20'
        alias -g NUL="> /dev/null 2>&1" # You get the idea.

    If you want to give a directory an alias, you use hash. `hash -d projs=~/projects/`

    Zsh also has suffix aliases, which means that you can tie a file suffix, let’s say “pdf” to a command, for example xpdf. `alias -s pdf=xpdf` Now if you just type the name of a pdf file, it will be displayed with xpdf. Similar to suffix aliases, if you turn on AUTO_CD, typing the name of a directory cd:s to it.

