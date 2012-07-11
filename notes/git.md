## Git1.6.3 introduced git difftool, originally proposed in September 2008:

   USAGE='[--tool=tool] [--commit=ref] [--start=ref --end=ref] [--no-prompt] [file to merge]'

(See --extcmd in the last part of this answer)

`$LOCAL` contains the contents of the file from the starting revision and `$REMOTE` contains the contents of the file in the ending revision.
`$BASE` contains the contents of the file in the wor

It's basically git-mergetool modified to operate on the git index/worktree.

The usual use case for this script is when you have either staged or unstaged changes and you'd like to see the changes in a side-by-side diff viewer (e.g. xxdiff, tkdiff, etc).

    git difftool [<filename>*]

Another use case is when you'd like to see the same information but are comparing arbitrary commits (this is the part where the revarg parsing could be better)

    git difftool --start=HEAD^ --end=HEAD [-- <filename>*]

The last use case is when you'd like to compare your current worktree to something other than HEAD (e.g. a tag)

    git difftool --commit=v1.0.0 [-- <filename>*]

Practical case for configuring difftool with your custom diff tool:

          C:\myGitRepo>git config --global diff.tool winmerge
          C:\myGitRepo>git config --global difftool.winmerge.cmd "winmerge.sh \"$LOCAL\" \"$REMOTE\""
          C:\myGitRepo>git config --global difftool.prompt false

With winmerge.sh stored in a directory part of your PATH:

     #!/bin/sh
     echo Launching WinMergeU.exe: $1 $2
     "C:/Program Files/WinMerge/WinMergeU.exe" -e -ub "$1" "$2"

If you have another tool (kdiff3, P4Diff, ...), create another shell script, and the appropriate difftool.myDiffTool.cmd config directive.
Then you can easily switch tools with the diff.tool config.

You have also this blog entry by Dave to add other details.

The interest with this setting is the winmerge.shscript: you can customize it to take into account special cases.