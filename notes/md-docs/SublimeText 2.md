#Sublime Text 2 for Ruby

- better than IDEs, except 
[Unix as IDE](http://blog.sanctum.geek.nz/series/unix-as-ide/)
###Why Sublime Text 2?

- Speed. It’s got the responsiveness of Vim/Emacs but in a full GUI environment. It doesn’t freeze/beachball. No need to install a special plugin just to have a workable “Find In Project” solution.
- Polish. Some examples: Quit with one keystroke and windows and unsaved buffers are retained when you restart. Searching for files by name includes fuzzy matching and directory names. Whitespace is trimmed and newlines are added at the end of files. Configuration changes are applied instantly.
- Split screen. I never felt like I missed this that much with TextMate, but I really appreciate it now. It’s ideal for having a class and unit test side-by-side on a 27-inch monitor.
- Extensibility. The Python API is great for easily building your own extensions. There’s lots of example code in the wild to learn from. (More about this later.) ST2 support TextMate snippets and themes out-of-the-box.
- Great for pair programming. TextMate people feel right at home. Vim users can use Vintage mode. When pairing with Vim users, they use command mode when they are driving. I just switch out of command mode and everything “just works”. (It also works on Linux, if that’s your thing.)
- Updates. This is mainly just a knock on TextMate, but it’s comforting to see new dev builds pushed every couple weeks. The author also seems to be quite responsive in the user community. A build already shipped with support for retina displays, which I believe is scheduled for a TextMate release in 2014.

###Getting Started

- I’ve helped a handful of new ST2 users get setup over the past few months. Here are the steps I usually follow to take a new install from good to awesome:
- Install the subl command line tool. Assuming ~/bin is in your path:

	ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/bin/subl
- It works like mate, but has more options. Check subl --help.
 
- Install [Package Control](http://wbond.net/sublime_packages/package_control). Package Control makes it easy to install/remove/upgrade ST2 packages.
- Open the ST2 console with Ctrl+` (like Quake). Then paste this Python code from this page and hit enter. Reboot ST2. (You only need to do this once. From now on you’ll use Package Control to manage ST2 packages.)

- Install the [Soda theme](https://github.com/buymeasoda/soda-theme). This dramatically improves the look and feel of the editor. Use Package Control to install the theme:
 
- Press ⌘⇧P to open the Command Palette.
- Select “Package Control: Install Package” and hit Enter.
- Type “Theme Soda” and hit Enter to install the Soda package.
- Start with a basic Settings file. You can use mine, which will activate the Soda Light theme. Reboot Sublime Text 2 so the Soda theme applies correctly. You can browse the default settings that ship with ST2 by choosing “Sublime Text 2” > “Preferences…” > “Settings Default” to learn what you can configure.
 
- Install more packages. My essentials are [SASS](http://sass-lang.com/), [RSpec](https://github.com/SublimeText/RSpec), [DetectSyntax](https://github.com/phillipkoebbe/DetectSyntax) and [Git](https://github.com/kemayo/sublime-text-2-git). DetectSyntax solves the problem of ensuring your RSpec, Rails and regular Ruby files open in the right mode.
- Sublime CodeIntel -
Maintianed by the same developer as SublimeLint, CodeIntel gives you IDE-style functionality with intelligent code completion, import suggestions, and go-to definition support.
It's really nice to have sometimes. I typically have it disabled. Give it a spin and see what you think. You can install it via Package Control. Learn more on [GitHub](https://github.com/Kronuz/SublimeCodeIntel).
 
- Ubuntu Mono -
I'm pretty passionate about monospace typefaces. Over the years, I've been a heavy supporter of Monaco, MS Consalas, Inconsolas, Menlo, and finally Ubuntu Mono.
Simply the greatest programming font ever made. [Download it here](http://font.ubuntu.com/).

- Install [CTags](https://github.com/SublimeText/CTags). CTags let you quickly navigate to code definitons (classes, methods, etc.). First:
 
	`$ brew install ctags`
- Then use Package Control to install the ST2 package. Check out the [default CTags key bindings](https://github.com/SublimeText/CTags#commands-listing) to see what you can do.

Leveling Up with Custom Commands

Sublime Text 2 makes it dead simple to write your own commands and key bindings in Python. Here are some custom bindings that I use:

- Copy the path of the current file to the clipboard.

```python
import sublime, sublime_plugin
import os

class CopyPathToClipboard(sublime_plugin.TextCommand):
  def run(self, edit):
    line_number, column = self.view.rowcol(self.view.sel()[0].begin())
    line_number += 1
    sublime.set_clipboard(self.view.file_name() + ":" + str(line_number))
```

- Close all tabs except the current one (reduces “tab sprawl”). 

```python
import sublime, sublime_plugin

	class CloseOtherTabs(sublime_plugin.TextCommand):
	  def run(self, edit):
	    window = self.view.window()
	    group_index, view_index = window.get_view_index(self.view)
	    window.run_command("close_others_by_index", { "group": group_index, "index": view_index})
```

- Switch between test files and class definitions (much faster than TextMate). 

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```

- Compile CoffeeScript to JavaScript and display in a new buffer. 
coffeescript.py

	```import sublime, sublime_plugin, subprocess, os
	
	
	# Run the `coffee` command synchronously, sending `input` on stdin.
	def coffee(extra_args, input):
	    command = ['coffee', '--stdio']
	    command.extend(extra_args)
	
	    try:
	        process = subprocess.Popen(command,
	            stdin=subprocess.PIPE,
	            stdout=subprocess.PIPE,
	            stderr=subprocess.PIPE)
	        stdin, stdout = process.communicate(input)
	        exit_code = process.wait()
	
	        return exit_code, stdin, stdout
	
	    except OSError as (errno, strerror):
	        if errno == 2:
	            path = os.environ['PATH']
	            message = "`coffee` couldn't be found on your $PATH:\n" + path
	            return -1, None, message
	        else:
	            raise
	
	
	# Base class for CoffeeScript commands
	class CoffeeCommand(sublime_plugin.TextCommand):
	    def is_enabled(self):
	        syntax_filename = os.path.basename(self.view.settings().get('syntax'))
	        return syntax_filename == 'CoffeeScript.tmLanguage'
	
	    def _show_in_panel(self, output):
	        window = self.view.window()
	        v = window.get_output_panel('coffee_output')
	        edit = v.begin_edit()
	        v.insert(edit, 0, output)
	        v.end_edit(edit)
	
	        window.run_command("show_panel", {"panel": "output.coffee_output"})
	
	
	# Compile the selected CoffeeScript and display it in a new window.  If no code
	# is selected, compile the entire file.
	class CompileAndDisplayJs(CoffeeCommand):
	    def run(self, edit):
	        window = self.view.window()
	
	        for region in self.view.sel():
	            if region.empty():
	                region = sublime.Region(0, self.view.size())
	
	            code = self.view.substr(region)
	
	            exit_code, compiled_code, error = coffee(
	                ['--compile', '--bare'], code)
	
	            if exit_code == 0:
	                v = window.new_file()
	                v.set_name("Compiled JavaScript")
	                v.set_scratch(True)
	                v.set_syntax_file('Packages/JavaScript/JavaScript.tmLanguage')
	
	                edit = v.begin_edit()
	                v.insert(edit, 0, compiled_code)
	                v.end_edit(edit)
	
	            else:
	                self._show_in_panel(error)
	                return
	
	
	# Run the selected CoffeeScript and display the results in the output panel.  If
	# no code is selected, run the entire file.
	class RunCoffeeScript(CoffeeCommand):
	    def run(self, edit):
	        window = self.view.window()
	
	        for region in self.view.sel():
	            if region.empty():
	                region = sublime.Region(0, self.view.size())
	
	            code = self.view.substr(region)
	
	            exit_code, output, error = coffee([], code)
	
	            if exit_code == 0:
	                self._show_in_panel(output)
	            else:
	                self._show_in_panel(error)
	                return```


New key bindings are installed by dropping Python class files in `~/Library/Application Support/Sublime Text 2/Packages/User` and then binding them from Default (OSX).sublime-keymap in the same directory. The ST2 Unofficial Documentation has more details.

rspec.py

```import sublime
import sublime_plugin
import os, errno
import re

def get_twin_path(path):
  spec_file = path.find("/spec/") >= 0

  if spec_file:
    if path.find("/lib/") > 0:
      return path.replace("/spec/lib/","/lib/").replace("_spec.rb", ".rb")
    else:
      return path.replace("/spec/","/app/").replace("_spec.rb", ".rb")
  else:
    if path.find("/lib/") > 0:
      return path.replace("/lib/", "/spec/lib/").replace(".rb", "_spec.rb")
    else:
      return path.replace("/app/", "/spec/").replace(".rb", "_spec.rb")

class OpenRspecFileCommand(sublime_plugin.WindowCommand):
  def run(self, option):
    self.views = []
    window = self.window
    current_file_path = self.window.active_view().file_name()

    spec_file = current_file_path.find("/spec/") > 0
    twin_path = get_twin_path(current_file_path)
    path_parts = twin_path.split("/")
    dirname = "/".join(path_parts[0:-1])
    basename = path_parts[-1]

    if not os.path.exists(twin_path) and sublime.ok_cancel_dialog(basename + " was not found. Create it?"):
      self.mkdir_p(dirname)
      twin_file = open(twin_path, "w")

      constant_name = self.camelize(basename.replace(".rb", "").replace("_spec", ""))

      if spec_file:
        twin_file.write("class " + constant_name + "\nend")
      else:
        twin_file.write("require \"spec_helper\"\n\ndescribe " + constant_name + " do\nend")
      twin_file.close()

    if os.path.exists(twin_path):
      view = window.open_file(twin_path)
      view.run_command("revert")
    else:
      sublime.status_message("Not found: " + twin_path)


  def mkdir_p(self, path):
      try:
          os.makedirs(path)
      except OSError as exc: # Python >2.5
          if exc.errno == errno.EEXIST:
              pass
          else: raise

  def camelize(self, string):
      return re.sub(r"(?:^|_)(.)", lambda x: x.group(0)[-1].upper(), string)

class RunTests(sublime_plugin.TextCommand):
  def run(self, edit, single):
    path = self.view.file_name()

    if path.find("/spec/") < 0:
      twin_path = get_twin_path(path)
      if os.path.exists(twin_path):
        path = twin_path
      else:
        return sublime.error_message("You're not in a spec, bro.")

    root_path = re.sub("\/spec\/.*", "", path)

    if single:
      line_number, column = self.view.rowcol(self.view.sel()[0].begin())
      line_number += 1
      path += ":" + str(line_number)
      command = "time rspec"
    else:
      command = "time ruby"

    cmd = 'osascript '
    cmd += '"' + sublime.packages_path() + '/User/run_command.applescript"'
    cmd += ' "cd ' + root_path + ' && ' + command + ' ' + path + '"'
    cmd += ' "Ruby Tests"'
    os.system(cmd)```


###list of basic things that are excellent time savers.

1. Multiple cursors: You can edit multiple lines of code simultaneously very easily by holding down Cmd (ctrl for Windows) and then clicking different lines with your mouse.
1. Reopening closed tabs: Just as with Chrome, if you accidentally close a file that you’d like to reopen, just press Shift +Cmd + T (or Shift + ctrl + T on Windows). If you keep pressing that key combo, ST will continue opening tabs in the order that you closed them.
1. Quick file opening: This is perhaps my favorite ST feature. Hold down Cmd + T (or ctrl + T on Windows) to open a textfield that lets you search for files within a project to open. You’ll rarely ever have to use the file tree again.
1. Jumping to symbols: To quickly jump to specific symbols, hold down Cmd + P (or ctrl + P on Windows) to open up a search field. Type in your symbol and press enter.
1. Search entire project files: To search the contents of an entire ST project, hold down Shift + Cmd + F (Shift + ctrl + F on Windows).
1. Jumping between words/lines: This is more of an operating system feature, but I discovered it while using ST. On Macs, if you hold down Alt while using the arrow keys, you jump between words rather than characters. Similarly, if you hold down Cmd while using arrow keys, you jump from the opposite end of a line. Very useful for quickly navigating code without your mouse.
1. Quickly change settings: Shift + Cmd + P (Shift + ctrl + P on Windows) opens a quick search to allow you to modify Sublime Text preferences.

The following have been additions I’ve seen in the Hacker News comments:

1. Jumping between word segments: ”If you hold down control, you move by word segment - this is camel-case (and underscore) aware. So, if I am at the front of the word “cakeParty”, I can move to between ‘e’ and ‘P’ by holding control and pressing the right arrow key.” (Thanks hebejebelus)
1. Move current line up/down: “You can also move the curent line up and down the page using Ctrl + Cmd + Up/Down” (Thanks draftable)
1. Sublime Package Control: “Useful for installing things like themes, syntax awareness, code linters, etc…” (Thanks po)
1. Quick word editing: “Cmd + d selects the current word. Subsequent Cmd + d presses will select the following instance of the word for editing. Makes it easy to do things such as renaming a local variable or changing both the opening and closing element of a HTML tag.” (Thanks haasted)
1. Fine-grained find+replace/modify: “Another one i’ve found useful is CMD+D / CMD+K+D. CMD+D finds the next instance of the current selection and creates another cursor there (and selects it as well). CMD+K+D skips the current selection and finds the next one.” (Thanks toran1302)
1. Select all instances: You can select all instances using cmd + ctrl + G (Thanks gryghostvisuals)
