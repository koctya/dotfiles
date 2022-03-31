# How to Use Bundler Instead of Rvm Gemsets

Listening to the latest [Ruby Rogues](http://rubyrogues.com/045-rr-bundler-with-andre-arko/) I was intrigued to hear André Arko describe how using bundler can completely obviate using rvm gemsets. He said that projects using bundler will just work if you have all of your gems piled together. No need to go through the hassle of managing a gemset for each project. I’m all about avoiding hassle, so I set out to investigate.

Now, don’t get me wrong: I love rvm. But I have to admit that managing gemsets and running bundle install from scratch again for every new project is a pain. I imagine that with this workflow I’ll still use rvm to manage Ruby versions, but not project gemsets.

## Use Bundler commands to have Ruby follow the Gemfile

*bundle exec* will run the given command within the context of the local Gemfile. That means that *bundle exec ruby* will run Ruby with the correct gem versions.

	# in savon_0.9.9
	% bundle exec ruby version.rb
	0.9.9
	
	# in savon_0.8.6
	% bundle exec ruby version.rb
	0.8.6

*bundle console* starts up an interactive Ruby session within the context of the local Gemfile so it’s exactly what we need to replace *irb*. It’s nifty in that it also automatically includes any gems specified in the Gemfile, no need to *require*!

	# in savon_0.9.9
	% bundle console
	1.9.3p0 :001 > Savon::Version
	 => "0.9.9"
	
	# in savon_0.8.6
	% bundle console
	1.9.3p0 :001 > Savon::Version
	 => "0.8.6"
	

## the bundler plugin in ZSH handles bundler exec automatically

If you’re using ZSH then you can add the bundler plugin and avoid some of these hoops. It has a function that checks to see if bundler is installed and if you’re in a directory with a Gemfile. If so, then if you run a command on its list of commands to run with bundle exec (e.g. cap, guard, heroku, ruby, rake) it will automatically wrap that command in bundle exec. Win. With that plugin in place, you can almost entirely just stop using gemsets and you’ll never have any problems.

## install to vendor

	bundle install --path vendor/bundle
