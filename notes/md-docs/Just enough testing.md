##Just enough testing
Posted: Thu, 12 Apr 2012 13:36:02 +0000


It’s happening again: An extremely successful software developer with a very large following lists his rules for success, and people jump for joy at the occasion, and use that list to justify their practices. That sounds great, doesn’t it?

While reading, [Testing like the TSA](http://37signals.com/svn/posts/3159-testing-like-the-tsa), I found myself nodding in agreement with what most David was suggesting. I didn’t agree with all of it, but that’s fine; there is definitely room for positive discussion and disagreement when it comes to solving problems with code. The best part about the blog post wasn’t the post itself. The comments and other discussion on sites like HackerNews are the real jewels.

I’d now like to think out loud about testing. We’ve come so far in the Ruby community, but in reality, we still have a long way to go.

###Just Enough Testing
A question that I hear constantly is, “How much tests should we have?” I always reply with, “Just Enough.” What does that mean exactly? It boils down to your application or library should have just enough tests that you are confident that it works as it should. Do I think your code base has enough tests? I don’t know. You should know. There isn’t a magic number. You’ll know when you’ve found it. Velocities will increase and regressions will decrease.

There’s a difference between spiking (or prototyping) and writing code that is destined for production.
Too many times, we see a blog post or a book that echoes our thoughts, and we grasp on to it as if were a gospel. When I see a comment that basically says, “… and that’s why I don’t test”, I think we should mark that as a failure. There are plenty of times when all of us don’t test. Last year, while I was learning Clojure, I didn’t write one test (and I still don’t). When I was learning how to write Android apps, I didn’t write tests either. The reason for this is because I wasn’t sure what I was writing. It’s pretty hard to describe the behavior of something with tests. It is even harder when you don’t know the language of description.

This can also be applied to web developers who develop web apps constantly. Sometimes we don’t know what we are trying to build. A little exploratory code helps us understand the problem. What we are looking for is the correct question and you might have to write a little code before understanding that. I suggest that after you learn the right question, you throw the prototype or spike away, and start again using TDD. That might not always be possible due to time or budgetary constraints, so you might have to retrofit it with tests later. This isn’t optimal, but it’s a part of being a professional developer. You can’t learn this by reading blog posts or books.

As an aside, I almost feel confident when test driving Android apps. It isn’t perfect, but I feel like this is the beginning of a conversation rather than any type of a complete solution.

####Testing for testing’s sake is a waste of time
You may remember back a few years ago when I spoke about TATFT. You might not have known it, but this was a short talk that was more parody than anything else. Many of you took this at face value. Doing that put you in the same place as taking the “Testing like the TSA” post at face value. You shouldn’t do that. The real value is understanding why we say what we say. I don’t write tests all the time. I do think constantly if I’m writing in a way to make things easily tested. I do write tests first most of the time. Keep in mind, I certainly don’t advocate that I or anyone else should write tests all the f#$@ time. That’s silly.

I rarely look at tools like code coverage or test to code ratios. That isn’t important to me. What I care about is is that the tests that I’ve written properly describe the behavior of the project. The times where code coverage and test to code ratios are important are as a metric over time. If these numbers are going down, it is a sign that code quality is decreasing. David pointed out in his post, “1:2 is a smell, above 1:3 is a stink.” You are going to have learn what’s good and bad on your own. Projects with different developers, with different problem domains will have different tolerances for smells.

###TDD is hard
TDD is hard. Think about the first time you sat down to write tests first. What was the first test you wrote? Does that test still exist? I sure hope not. Red, Green, Refactor is a catchy slogan. It seems easy to write a failing test, write some code to make it pass, than refactor. It isn’t, unfortunately. There are some good books on the subject. [Test Driven Development by Example](http://www.amazon.com/Test-Driven-Development-By-Example/dp/0321146530) (the Kent Beck book) is one people always talk about. [Growing Object-Oriented Software, Guided by Tests](http://www.amazon.com/Growing-Object-Oriented-Software-Guided-Tests/dp/0321503627/ref=sr_1_1?s=books&ie=UTF8&qid=1334236065&sr=1-1) is much better, and definitely belongs on everyone’s bookshelf.

You also have to remember that TDD is just a suggestion. Take what works for you and form your own opinions. I personally believe in Write a Test, Make it Pass, or Change the Message. This allows me an easier logical transition between Red and Green.

The one thing I can promise you is that with practice and anger, you’ll learn what does and does not work. The goal here is get working software that you can trust as fast as you can.

####Don’t use tool X
I feel like this is always bad advice. Some people like RSpec and some don’t. Some people have had great results with Cucumber, while some flail with it. At one time, all of us knew nothing about code. We found a language we liked, and learned how to be productive with it. Sometimes tools aren’t productive because you aren’t using them right. Sometimes tools are just bad. I appreciate that we have a myriad of tools for our arsenals.

####Don’t test your web framework
I don’t have much to say about this. Don’t test it until you absolutely have to. Think twice before writing tests for that validation. In our Rails projects, we should be thinking about behaviors of objects and interactions between objects. Your unit tests should reflect that. Your acceptance tests verify the orchestration of those units. Simple, right?

##My gitconfig
Posted: Fri, 16 Mar 2012 19:14:07 +0000

Here’s my gitconfig, I thought I’d share.

  # put this at ~/.gitconfig

	[alias]
	
	  # I'm lazy, so two letters will always trump the full command
	  co = checkout
	  ci = commit
	  cp = cherry-pick
	  st = status
	  br = branch
	  df = diff
	  lg = log -p
	
	  # Show the log, with the diff +'s and -'s
	  lc = log ORIG_HEAD.. --stat --no-merges datetag = "tag `date '+%Y%m%d%H%M'`"
	  
	  # The first thing I run on a new project. Who has done the most damage
	  who = shortlog -s --
	
	  # random stuff cargoculted from who knows where
	  graphviz = "!f() { echo 'digraph git {' ; git log --pretty='format:  %h -> { %p }' \"$@\" | sed 's/[0-9a-f][0-9a-f]*/\"&\"/g' ; echo '}'; }; f"
	  lol = log --pretty=oneline --abbrev-commit --graph --decorate
	  up = !sh -c 'git pull && git log --pretty=format:"%Cred%ae %Creset - %Cyellow%s %Creset%ar" HEAD@{1}..'
	  msgforsvn = log --pretty=format:\"%h\t%b\"
	  svnfind = !sh -c 'git msgforsvn | grep -e \\@$0 | cut -f 1'
	  alias = !git config --list | grep 'alias\\.' | sed 's/alias\\.\\([^=]*\\)=\\(.*\\)/\\1\\t=> \\2/' | sort
	
	        
	[user]
	  name = myuser
	  email = me@example.com
	
	[color]
	  diff = auto
	  status = auto
	  branch = auto
	  ui = auto
	
	[core]
	  excludesfile = /Users/bryan/.gitignore
	
	[github]
	  user = githubuser
	  token = 12345
	
	[difftool "Kaleidoscope"]
	  cmd = ksdiff-wrapper git \"$LOCAL\" \"$REMOTE\"
	[mergetool "chdiff"]
	   cmd = /usr/bin/env chdiff --wait "$LOCAL" "$REMOTE"
	   keepBackup = false
	   trustExitCode = false
	[push]
	  default = tracking
	[difftool]
	  prompt = false

##My new funky editor. A story about Sublime Text 2
Posted: Fri, 20 Jan 2012 15:49:51 +0000


####A prologue
Today, I use [Sublime Text 2](http://www.sublimetext.com/) for just about all my text editing needs. It is fast and fairly stable. It is customizable and it can use plugins from Textmate. It also allows me to have split windows and its concept for finding files, methods, and editor actions make me a productive developer.

Over the years, I’ve used a myriad of text editors. Most of my time has been spent in Vim. My fingers are so used to Vim’s modal editing, I tend to expect the world to move up or down when I press j or k. Every time I’ve tried out new editors, I’ve always missed h/j/k/l. Sublime Text 2′s Vintage editing mode satisfies most of my modal editing needs. All the important commands are there, and new ones are added as users request them.

One big issue I’ve had with editors that can be extended by code, is that the language used for extension isn’t very friendly. I’m not well versed in Lisp, but I can get around. Emac’s ability to be customized is unsurpassed, but personally I don’t feel that I need a complex environment with an editor as a bonus. Most times I just want to create text. On the other hand, Emac’s Org Mode is unsurpassed, so I do find myself wishing that it existed in other places with the same amount of functionality as the the original.

Vim’s vimscript is more than functional. It can be used to create some truly useful plugins. Tim Pope has proven this time and time again. The problem with vimscript is that is really only useful inside of vim. Vim also allows you to extend it using other languages, such as Python and Ruby, but I haven’t explored either of those enough to comment on them.

I tried Sublime Text 2 as a diversion from my normal editor, MacVim. I’d been hearing many things about it, so I wanted to try it out. It passed the 5 minute red face test with ease, so I decided to use it exclusively for a two week period. That was over a month ago, and now I’ve purchased it as well.

# Pros and cons to RubyMine and TextMate, Sublime Text 2

I need to move to a "serious" Ruby (on Rails) IDE now that Netbeans is discontinuing Ruby support. I don't want to start a trolling war, but could I'd love to hear the pros and cons of using TextMate or RubyMine as an IDE, to help me choose which I should invest my time in, especially from people who are using one of them daily ("in the trenches").

## Requirements
- True Graphical environment
- Strong keyboard support
- Project file browser
- Snippets support
- Language support

###text-editors -- vs -- IDEs:
- text-editors 
	- Faster
	- More customizable, - can be configure to fit your specific needs more so than an IDE.
- IDEs
	- slow and bloated, not as lightweight
	- consume more power/memory and resources in general
	- This difference means a lot when you want to work with languages like Java, that has a lot of syntactic bagage, which is more productive with good IDE support

####Eclipse (IDE)
####RubyMine (IDE)

- Pros:
	- Frequent updates
	- Ruby/Rails focused, plus built-in support for common gems
	- It's actually an IDE.
	- Autocomplete 
	- Great refactoring tools
	- Good VCS (GIT specially) integration.
- Cons: 
	- Things like refactoring/autocomplete are easy to confuse (I've been trying the RubyMine trial for the last few days)
	- It's actually an IDE
		
	- It can stall from time to time


####TextMate

- Pros: 
	- Seems to be the de facto standard
	- supports a BIG list of languages
 	- is the choice of most serious Rails devs.
- Cons: 
	- it is only for OSX. 
	- I'm a bit concerned that updates are few and far between
	- I come from a Java background, so such a lightweight editor (rather than a heavyweight IDE) would be a bit of a culture-shock to me


####Sublime Text 2. 
At first glance, this editor is beautiful. It has the prettiest indent guides I’ve ever seen and lovely syntax highlighting. It has an excellent set of themes including the full set of tomorrow night themes which I used the most at the time. It is also a highly extensible editor. Plugins are written in Python and aren’t very difficult to write if you can read an existing plugin or manage to find up-to-date information about them. 

- Pros:
	- It also has support for most TextMate snippets, themes, etc. 
	- it’s interface to be simple, clean, and yet still beautiful. 
	- The default color scheme is a sane, dark theme. Code colors and highlights are simple and clear.
	-  parenthesis (or other paired punctuation)?  created in pairs and cursor placed between them! I start typing out my functions and it indents perfectly. It recognizes my statements and indents appropriately.
	- Really F***ing Fast - Opens practically instantly. 
	-  I created a symlink (like “sudo ln -s /home/shepbook/Sublime\ Text\ 2/sublime_text /usr/bin/subl”) and I can start it with my ALT+F2 run command option in Gnome, just by typing in “subl” (of course, one could do this from your terminal as well). Even better, I can open a folder in the same way, like “subl /path/to/folder” and Sublime Text opens it in the left side bar.
	- Magical “GoTo Anything” search
	> Press CTRL+P and you get this handly little drop down box. Start typing and you can search for any file in your project. It searches for both filenames and complete paths. Then, once you find the file, you can type “@” and it give you a list of all the methods in the file. Need to jump to a line in that file? Some Vim awesomeness has carried over (since it was originally inspired by Vim)… just CTRL+P and then type “:” followed by the line number.
	
	- Sublime Package Control There’s a thing called “Package Control” for Sublime Text and it makes installing plugins and extensions a piece of cake.
	- Git Control
	- Many More Plugins There are lots more plugins, which warrent your looking through them. There’s a linter, code completion, word highlights.
	- Simple Configuration; There are no crazy menus or configuration tools you have to nagivate through, in order to customize Sublime Text 2. Instead, everything is easily configured in simple text files. While some may not consider this “easier”, it is simpler. 

Besides all the time I save by using it, it simply makes coding better. 

####Emacs

- non-graphical (XEmacs isn't either, its just a prettier version of the ncurses interface!)

####VI
>VI is at the center of evil
 	- Eric Raymond

VIM is popular with some in the Ruby comunity, how ever others like myself just cannot get the modal editing mode rooted in the past when terminals were teletypes.

- non-graphical
- Its learning curve is too steep.

#### Gedit
it is the Gnome equivalent to Kwrite. I had used both on occasion and found myself going back to them. Tabs for my files and easier management were significant advantages I found. Gedit definitely made my life easier. 