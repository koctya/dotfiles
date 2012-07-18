# Rails notes

Setting up a new rails project.

    $ rails new samp-app -T

    $ cd samp-app

    $ git_here

    $ emacs Gemfile

    $ git add .

    $ gc -m"Initial checkin"

    $ rails g cucumber:install --capybara

    $ rails g rspec:install

    $ rails g jasmine:install

    $ rails g foundation:install

## Gemfile

    ```ruby
    source  :rubygems

    gem 'rails', '3.1.3'

    platforms :ruby do
      gem 'sqlite3'
      gem 'therubyracer'
    end

    group :assets do
      gem 'sass-rails',   '~> 3.1.5'
      gem 'coffee-rails', '~> 3.1.1'
      gem 'uglifier'
      gem 'zurb-foundation'
      gem 'compass'
      gem 'haml-rails'
    end

    gem 'cells'
    gem 'jquery-rails'
    gem 'execjs'


    group :development, :test do
      gem 'pry'
      gem 'awesome_print'
      gem 'rspec-rails'
      gem 'rspec-cells'
      gem 'cucumber-rails'
      gem 'database_cleaner'
      gem 'capybara'
      gem 'launchy'
      gem 'factory_girl_rails'
      #gem 'machinist'        # experimenting with machinist
      gem 'jasmine'
    end

    group :test do
      gem 'simplecov', :require => false  # will install simplecov-haml as a dependency
    end

    platforms :mswin do
    end

    platforms :jruby do
      gem 'activerecord-jdbcsqlite3-adapter',  :require => false
      gem 'jdbc-sqlite3', :require => false
      gem 'jruby-openssl', :require => false
      gem 'trinidad'
      gem 'therubyrhino'
      gem 'warbler'
    end
    ```

### If deploying using jruby
    warble config
    emacs config/warbler.rb

edit lib/tasks/warbler.rake
    ```ruby
    require 'warbler'
    Warbler::Task.new
    ```
## Dead Simple Rails Config

Rails 3 makes adding custom configuration dead simple. You don't have to shouldn't add a dependency. Here's how easy it is:

>This method provides custom configuration without checking it in to version control. It's even easier if your configuration settings do not need to be private.
#### Easy Access

There are two ways to access our application's configuration object in Rails 3.

      MyApp::Application.config
      # or
      Rails.application.config

In my opinion, both of these are too verbose, so I add a convenience method to config/application.rb just inside my application's top-level module:

   module MyApp
     def self.config
         Application.config
     end
   end

Now we have easy access to the configuration object:

    MyApp.config

Right now that object is a bucket full of Rails configurations. How do we get our own settings in there?

#### Just add Yaml

Add a config.yml file to our app's config directory. Put some settings in there.

    site_name: "My Application"
    contact_email: "email@myapp.com"

Copy the file to a new one called `config.yml.example`. Gitignore the real one. Check the example in to version control.

     cp config/config.yml config/config.yml.example
     echo "config/config.yml" >> .gitignore

#### Load it

We can add custom settings to Rails' configuration manually like so:

   module MyApp
     class Application < Rails::Application
         config.site_name = "My Application"
     end
   end

But we want to load in all the settings from `config.yml`, so manual ain't gonna cut it. Instead, load the Yaml file and send setter methods to the `Application` object for each setting, like so:

    # inside MyApp::Application class
    YAML.load_file("#{Rails.root}/config/config.yml").each { |k,v| config.send "#{k}=", v }

### New Gem: Rack-noIE6
18 Apr 2009
Many web developers are discontinuing support for IE6. I, happily, am one of them (unless a client demands it). The other day I went searching for an IE6 detection and redirect solution to aide in my un-support of the browser. What I found was pretty rad.

Now that Rails is on Rack, dozens of useful middleware apps are being developed and can be plugged into Rails with ease. Thanks to a simple GitHub search, I found the [rack-noie](http://github.com/juliocesar/rack-noie/tree/master) project by Julio Cesar.

His middleware did almost exactly what I wanted except for a few small things. First, I prefer using gems with Rails so dependencies can easily be managed using config.gem. Second, we're just hating on IE6, not IE in general. Therefore, the name is a bit misleading.

So, in the spirit of open-source, I forked his project and molded it to my liking. You can see the shiny new rack-noie6 gem's GitHub page here.

Its dead simple to integrate. First, install the gem

    gem install rack-noie6

Next (if you're using Rails), add the following to environment.rb inside the Rails::Initializer.run block:

    config.gem 'rack-noie6', :lib => 'noie6'
    config.middleware.use "Rack::NoIE6"

As the IE6-BraveHeart would proclaim: FREEEEDOMMMM!

### Dead Simple Rails Deployment

Deploying a Rails app used to suck. Reverse proxies, Mongrel clusters, Monit, etc. Capistrano helped out a lot (once you set it up the first time), but all in all the process was still pretty painful.

Thankfully, a couple of technologies have come along and made my deployment process a whole lot easier.

1. Passenger This was the big one. The Phusion guys' "Hello World" app (as they called it) has really had a positive impact on the Rails community, and me personally. Suddenly my Rails (and Rack) web apps are first class citizens to Apache (and Nginx), which means I can just point a virtual host at the public directory and go. I had almost forgotten how good it feels to just drop some files in a directory and have Apache serve them.
2. Git Ok, so maybe Subversion allows a similar workflow, but for some reason Git is one of those tools that is so much fun to use that it makes me think of different ways I can use it.

#### My Flow

How I deploy these days (when I'm not deploying to Heroku) is dead simple. I host my private Git repos using Gitosis, but the same would work with GitHub or any Git server.

#### Initial Setup

1. Clone the repository on production server.
2. Create database.yml and any other production-specific configs
3. Configure an Apache virtual host pointing to "public" folder of the repository
#### Deploys

locally:

    jerod@mbp:~$ git push origin master

remotely:

    jerod@mbp:~$ git pull origin master && touch tmp/restart.txt

I know what you're thinking, "Wow, that is dead simple". It's even easier by using Capistrano to execute the remote commands. Here is an example Capistrano task from one of my Rails apps:

    task :deploy, :roles  => :production do
      system "git push origin master"
      cmd = [ "cd #{root_dir}", "git pull", "touch tmp/restart.txt" ]
      run cmd.join(" && ")
    end

This task can be extended to automatically install required gems, update Git submodules, migrate the database, and so on.

#### Other Benefits

Besides the simplicity and ease of deployment in this process, I have also enjoyed the ability to make edits in production and pull them back in to my development environment. And because my production environment has a complete history of code changes, it is trivial to revert commits that cause major problems.

This work flow is by no means a panacea. How do you handle deployment?

