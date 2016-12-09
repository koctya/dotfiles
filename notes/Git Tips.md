# Git Tips

## Comparing Files from Different Branches with Git Difftool

### What is Git Difftool?

According to the man page for git-difftool,

    git difftool is a git command that allows you to compare and edit files between revisions using common diff tools. git difftool is a frontend to git diff and accepts the same options and arguments.

I've tried using `git diff` in the past and, after spending years working with a wonderful tool like Subclipse's Synchronize with Repository, I just did not enjoy the output of git diff at all. Luckily, git difftool works with a file compare tool on your system, making the output much easier (for me at least) to deal with. On my system, which is OS X, because I have the Apple Developer Tools installed, when I issue the git difftool the output is sent to opendiff, which in turn uses FileMerge which is a nice, graphical file compare and merge tool. Other than installing the developer tools, which I did long before I started using Git, I didn't have to do any other setup. I honestly have no idea how easy it is to set up a graphical compare tool to work with git difftool on a Windows or Linux box, but I'm guessing it cannot be that difficult.

### Using Git Difftool

To start a compare, you simply issue the git difftool command and pass it paths to two sets of files. The paths look like branchName:path. So if I wanted to compare the file ValidationFactory.cfc from the master branch to the same file in the newStuff branch, I'd type:

    1 git difftool master:ValidationFactory.cfc newBranch:ValidationFactory.cfc

I'd see a prompt that says something like:

    1 merge tool candidates: opendiff kdiff3 tkdiff xxdiff meld kompare gvimdiff diffuse ecmerge araxis emerge vimdiff
    2 Viewing: 'master:ValidationFactory.cfc'
    3 Hit return to launch 'opendiff':

And when I hit return FileMerge would open up with both files displayed. If I want to compare an entire folder, I can just type

    1 git difftool master:ValidateThis/core/ newBranch:ValidateThis/core/

And then I receive that prompt for each individual file in turn.

I still don't think this is anywhere near as good as what I had with Subclipse, and I'm guessing there are ways to configure it to make it even friendlier, but for now it's much better than git diff.

## Git Tip: How to "Merge" Specific Files from Another Branch
### Problem Statement

Part of your team is hard at work developing a new feature in another branch. They've been working on the branch for several days now, and they've been committing changes every hour or so. Something comes up, and you need to add some of the code from that branch back into your mainline development branch. (For this example, we'll assume mainline development occurs in the `master` branch.) You're not ready to merge the entire feature branch into `master` just yet. The code you need to grab is isolated to a handful of files, and those files don't yet exist in the `master` branch.

#### Buckets o' Fail
This seems like it should be a simple enough task, so we start rummaging through our Git toolbox looking for just the right instrument.

**Idea, the First**. Isn't this exactly what `git cherry-pick` is made for? Not so fast. The team has made numerous commits to the files in question. `git cherry-pick` wants to merge a commit - not a file - from one branch into another branch. We don't want to have to track down all the commits related to these files. We just want to grab these files in their current state in the feature branch and drop them into the `master` branch. We could hunt down the last commit to each of these files and feed that information to `git cherry-pick`, but that still seems like more work than ought to be necessary.

**Idea, the Second**. How 'bout `git merge --interactive`? Sorry. That's not actually a thing. You're thinking of `git add --interactive` (which won't work for our purposes either). Nice try though.

**Idea, the Third**. Maybe we can just merge the whole branch using `--squash`, keep the files we want, and throw away the rest. Um, yeah, that would work. Eventually. But we want to be done with this task in ten seconds, not ten minutes.

**Idea, the Fourth**. When in doubt, pull out the brute force approach? Surely we can just check out the feature branch, copy the files we need to a directory outside the repo, checkout the `master` branch, and then paste the files back in place. Ouch! Yeah. Maybe, but I think we might have our Git license revoked if we resort to such a hack.

#### The Simplest Thing That Could Possibly Work
As it turns out, we're trying too hard. Our good friend git checkout is the right tool for the job.

    git checkout source_branch <paths>...

We can simply give `git checkout` the name of the feature branch [1] and the paths to the specific files that we want to add to our master branch.

    $ git branch
    * master
      twitter_integration
    $ git checkout twitter_integration app/models/avatar.rb db/migrate/20090223104419_create_avatars.rb test/unit/models/avatar_test.rb test/functional/models/avatar_test.rb
    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #   new file:   app/models/avatar.rb
    #   new file:   db/migrate/20090223104419_create_avatars.rb
    #   new file:   test/functional/models/avatar_test.rb
    #   new file:   test/unit/models/avatar_test.rb
    #
    $ git commit -m "'Merge' avatar code from 'twitter_integration' branch"
    [master]: created 4d3e37b: "'Merge' avatar code from 'twitter_integration' branch"
    4 files changed, 72 insertions(+), 0 deletions(-)
    create mode 100644 app/models/avatar.rb
    create mode 100644 db/migrate/20090223104419_create_avatars.rb
    create mode 100644 test/functional/models/avatar_test.rb
    create mode 100644 test/unit/models/avatar_test.rb
    
    Boom. Roasted.
    
###### Notes
[1] git checkout actually accepts any tree-ish here. So you're not limited to grabbing code from the current tip of a branch; if needed, you can also check out files using a tag or the SHA for a past commit.

## Github

### Fork A Repo

At some point you may find yourself wanting to contribute to someone else's project, or would like to use someone's project as the starting point for your own. This is known as "forking." For this tutorial, we'll be using the Spoon-Knife project.

####  Configure remotes

When a repo is cloned, it has a default remote called `origin` that points to your fork on GitHub, not the original repo it was forked from. To keep track of the original repo, you need to add another remote named `upstream`:

More about remotes
>A remote is a repo stored on another computer, in this case on GitHub's server. It is standard practice (and also the default when you clone a repo) to give the name origin to the remote that points to your main offsite repo (for example, your GitHub repo).
Git supports multiple remotes. This is commonly used when forking a repo.

    cd Spoon-Knife
    # Changes the active directory in the prompt to the newly cloned "Spoon-Knife" directory
    
    git remote add upstream https://github.com/octocat/Spoon-Knife.git
    # Assigns the original repo to a remote called "upstream"
    
    git fetch upstream
    # Pulls in changes not present in your local repository, without modifying your files

##### Push commits

Once you've made some commits to a forked repo and want to push it to your forked project, you do it the same way you would with a regular repo:

More about commits
>Think of a commit as a snapshot of your project — code, files, everything — at a particular point in time. After your first commit git will only save the files that have changed, thus saving space.

    git push origin master
    # Pushes commits to your remote repo stored on GitHub

##### Pull in upstream changes

If the original repo you forked your project from gets updated, you can add those updates to your fork by running the following code:

    git fetch upstream
    # Fetches any new changes from the original repo

    git merge upstream/master
    # Merges any changes fetched into your working files

##### What is the difference between fetch and pull?
There are two ways to get commits from a remote repo or branch: git fetch and git pull. While they might seem similar at first, there are distinct differences you should consider.

###### Pull

    git pull upstream
    # Pulls commits from 'upstream' and stores them in the local repo

When you use `git pull`, git tries to automatically do your work for you. It is context sensitive, so git will merge any pulled commits into the branch you are currently working in. One thing to keep in mind is that `git pull` automatically merges the commits without letting you review them first. If you don't closely manage your branches you may run into frequent conflicts.

###### Fetch & Merge

    git fetch upstream
    # Fetches any new commits from the original repo
    
    git merge upstream/master
    # Merges any fetched commits into your working files

When you `git fetch`, git retrieves any commits from the target remote that you do not have and stores them in your local repo. However, it does not merge them with your current branch. This is particularly useful if you need to keep your repo up to date but are working on something that might break if you update your files. To integrate the commits into your local branch, you use `git merge`. This combines the specified branches and prompts you if there are any conflicts.

#### Pull requests

If you are hoping to contribute back to the original fork, you can send the original author a pull request.

### Task lists

In GitHub markdown you can create task lists.

- [x] task 1
- [ ] task 2
- [ ] task 3

If you embed this task list in the initial comment section of your PR then it can be seen on the GitHub pull request page

# More resources

[GitHub cheat sheet](https://github.com/tiimgreen/GitHub-cheat-sheet)


