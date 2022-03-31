# Sublime Text 3 
Is an amazing piece of software. To start, it is a clean, functional, and fast code editor. Not only does it have incredible built in features (multi-edit and vim mode), but it has support for plugins, snippets, and many other things.

## Features

### COMMAND PALETTE `⌘ + ⇧ + P`

The command palette let’s you access pretty much anything in the settings menus, call your package commands, change file syntax, handle Sublime projects, and so much more.

For instance, you are able to call Git commands add, branch, commit, push, and pull all from the command palette.

### FILE SWITCHING `⌘ + p`

Sublime Text provides a really fast way to open up new files. Just press ctrl + p and start typing the name of the file you want. Once it shows up, just press enter and start typing directly into that file!

### GOTO SYMBOLS `⌘ + R`

When you have a large file with a bunch of methods, pressing ctrl + r will list them all and make them easier to find. Just start typing the one you want and press enter.

Sublime Text 3 also has a new feature (Goto Definition). It provides Sublime Text with more capabilities closer to an IDE.

### MULTI-EDIT `⌘ + CLICK`

This is in my opinion, the absolute best feature of Sublime. After using it here, it’s hard to go back to other text editors. There are many different ways to use multi-edit:

`ctrl + d`: Select the current word and the next same word
`ctrl + click`: Every place you click will create a cursor to edit
`ctrl + shift + f` AND `alt + enter`: Find a word in your files and then select them all

### SNIPPETS

Snippets are yet another great feature of Sublime Text. You can use the pre-installed ones, build your own, or install a package that has more. All you have to do is type in a word and it will expand into your snippet. For example, typing lorem will generate lorem ipsum text.

To Use: Type a word that activates a snippet (ie lorem) and press tab.

### KEYBOARD SHORTCUTS

The amount of keyboard shortcuts in Sublime are astounding. This is the other absolute best feature of Sublime. 
The less I can move away from the home keys on my keyboard, the more efficient I can be.

For a full list of the Sublime Text Keyboard Shortcuts, take a look at the
[keyboard shortcuts article](https://scotch.io/bar-talk/sublime-text-keyboard-shortcuts).

### PROJECTS

Projects is an integral part of my workflow in Sublime Text. A project is just a Sublime workspace in which your folders are open and stored in the sidebar. This helps since you can define a project and add folders to it, and be able to switch between folders quickly.

Using projects, you will no longer have to go digging in Windows Explorer or Finder to get the project you want and drag it into Sublime.

To Save a Project: Go into the command palette and type `save project`

To Switch Projects: `⌘ + alt + p`

### Column and Row Workspace Panes

Are you more a productive coder with multiple files open? ST3, like any good text editor, 
allows you to see files side by side, so that you won’t be switching back and forth between an HTML file and its CSS document:

To view two column (vertical) panes side-by-side use the shortcut `OPTION-⌘-2`. Replace the last stroke with “3” or “4” to view three or four panes respectively. Using “5” produces a 4 pane grid.

To view two row (horizontal) panes side-by-side use the shortcut `SHIFT-OPTION-⌘-2`. Replace the last stroke with “3” to view three panes respectively.

### Quickly Comment Your Code

This is a useful tip if you’re constantly commenting your code or for temporarily testing how disabling a block of code 
affects your project. To comment code quickly in ST3, highlight the code and use `⌘-/` If you don’t highlight any code, 
using this shortcut will comment out the entire line.

### Indent Quickly

Developers know the importance of indentation because it keeps your code legible and easier to understand. 
If you want to increase the current line’s indent, use `⌘-]`. Decreasing the indent uses the other square bracket key `⌘-[`.

# Sublime text packages
Apple 	⌘ + ⎇ + v

- [ALIGNMENT:]()
  A very simple and easy to use plugin. I’m a very big fan of making your code organized and good looking. It helps tons when you revisit the code later down the road. Alignment helps with that.

  To Use: Highlight the lines you want to align and press `⌘ + ^ + a`
- [COLORPICKER]() `ctrl + shift + c` Have the ability to change colors with a colorpicker on the fly.
- [Sidebar Enhancements](https://github.com/titoBouzout/SideBarEnhancements)
- [JSLint:](https://github.com/fbzhong/sublime-jslint) A must have for JavaScript programmers, jslint is a code analysis and quality management tool.
- [Git](https://github.com/kemayo/sublime-text-2-git/) If you are a heavy git user, this is a must have plugin. You can use git completely within ST.
- [GitGutter:](https://github.com/jisaacks/GitGutter) Although you can run Git commands from within Sublime Text, why check the differences in a file from the last commit by running a separate command when you can view it in real time?
- [SublimeCodeIntel:](https://github.com/Kronuz/SublimeCodeIntel) Last, but not least, a plugin that brings common IDE functions like Auto-complete, Function Tooltips and jumps to symbol definitions; to Sublime Text.
- [Emmet:]() A must have for HTML/CSS web-developers, it greatly enhances the idea of snippets and guaranteed to speed up your development time.
- [MarkdownEditing:](https://github.com/SublimeText-Markdown/MarkdownEditing) Markdown plugin for Sublime Text. Provides a decent Markdown color scheme (light and dark) with more robust syntax highlighting and useful Markdown editing features for Sublime Text. 3 flavors are supported: Standard Markdown, GitHub flavored Markdown, MultiMarkdown.
- [MarkdownPreview:](https://github.com/revolunet/sublimetext-markdown-preview) Although many developers prefer to create Markdown files in the cloud (GitHub Gists, StackEdit, Markable), this is for the ‘old school’ writers who prefer to keep their files locally.
- [CSSComb:](http://csscomb.com/) CSSComb is a plugin to sort CSS properties. 
- [FileDiffs:](https://github.com/colinta/SublimeFileDiffs) FileDiffs allows you to see the differences between two files in SublimeText
- Snippets can help you write code faster by reusing code pieces. While you can also create your own set of code snippets, there are several snippet packages ready for use right away. Here are just some of them:
  - [Foundation](https://github.com/zurb/foundation-5-sublime-snippets) – A collection of snippets to build Foundation 5 framework components such as the Buttons, Tabs, and Navigation.
  - [Bootstrap 3](https://github.com/JasonMortonNZ/bs3-sublime-plugin) – If you prefer Bootstrap, try this.
  - [Bootstrap 3 for Jade](https://github.com/rs459/bootstrap3-jade-sublime-plugin) – This plugin combines Bootstrap 3 with Jade syntax.
  - [jQuery Mobile](https://github.com/MobPro/Sublime-jQuery-Mobile-Snippets) – A collection of snippets to build jQuery Mobile components and layouts.
  - [HTML5 Boilerplate](https://github.com/sloria/sublime-html5-boilerplate) – this snippet lets you create HTML5 Boilerplate documents in a snap.
  - [Node.js](https://github.com/tanepiper/SublimeText-Nodejs)
  - [Angular](https://github.com/angular-ui/AngularJS-sublime-package)
  - [Ruby on Rails](https://github.com/tadast/sublime-rails-snippets)

- Additional Syntax Support
  Languages that are not supported in SublimeText may not display with proper syntax highlighting. They include LESS, Sass, SCSS, Stylus, and Jade, so if you are working with those languages, here are the plugins to install, for syntax support.
  - [Sass](https://github.com/nathos/sass-textmate-bundle)
  - [Jade](https://github.com/P233/Jade-Snippets-for-Sublime-Text-2)
  - [CoffeeScript]
- [LaTeX Plugin for Sublime Text 2 and 3](https://github.com/SublimeText/LaTeXTools) This plugin provides several features that simplify working with LaTeX files:
