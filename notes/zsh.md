# ZSH

## [Zsh is your friend](http://mikegrouchy.com/blog/zsh-is-your-friend.html)
### Why is Zsh better than Bash?

- one of the most important reasons why Zsh is better than bash is autocompletion
- shared history

Lets use Kill as an example. You type

Kill <tab>
in bash, you get what, the list of all files that are in your current working directory. Not very helpful behavior in my opinion. What happens if you type

kill <tab>
in Zsh? Lists of all your processes with pids? Yes please.

- Time for more awesome

Autocorrect is pretty cool

    git:(master) ✗ » gut status
    zsh: correct 'gut' to 'git' [nyae]?y
    git status

Hey thats pretty cool, autocorrect for known commands.

- Zsh has [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) from the website:

> A community-driven framework for managing your zsh configuration. Includes 40+ optional plugins (rails, git, OSX, hub, capistrano, brew, ant, macports, etc), over 80 terminal themes to spice up your morning, and an auto-update tool so that makes it easy to keep up with the latest updates from the community.

If you are interested in learning more about Zsh, check out the [Zsh FAQ](http://zsh.sourceforge.net/FAQ/).
or the [Zsh Guide](http://zsh.sourceforge.net/Guide)
