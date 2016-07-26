# GitHub


Instead of storing my GitHub token in a file, I store it in my OS X Keychain and get it like this (snippet from my .gitconfig):

[github]

      token = !security find-generic-password -gs \"GitHub API Token\" 2>&1 >/dev/null | awk '/password/ {print $2}' | tr -d \\\"
