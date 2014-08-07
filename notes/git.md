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

### Amending Git Commits

You can fix you're previous commit (modify commit message, add more files, etc.) quite easily with git. An example:

You're in early stages of developing a Rails app and you decide that you want to go back and add some indexes to your tables. No need to create a new migration at this point, just add the indexes to the old migrations and run them again. After making the changes, you create a commit

    git commit -a -m "Added missing indexes to tables"

Next you re-run all your migrations to get the indexes in there.

    rake db:migrate:reset

At this point, you check git status and remember that now your schema file has changed. This probably should have been included in the last commit! Piece of cake.

    git commit db/schema.rb --amend

You'll be prompted to optionally change the commit message.

At this point git status will tell you that your working directory is clean and the changes to your schema were tracked in the same commit as the migration changes.

Butter.


# caring about the project history

Submitted by ao2 (not verified) on Mon, 10/03/2011 - 03:53
git bisect is great. And it is another reason for caring about the project history (I mean the commit history in this context):

    don't put logically unrelated changes in the same commit;
    don't mix functional changes with cosmetic changes;
    attribute changes to the original authors, so you know whom to ask about the change causing the problem; and they also take the blame :)

Those simple rules are generic but they have the side effect of making bisecting ever more effective.

# Submodules

http://www.git-scm.com/book/en/Git-Tools-Submodules

http://longair.net/blog/2010/06/02/git-submodules-explained/

https://git.wiki.kernel.org/index.php/GitSubmoduleTutorial
