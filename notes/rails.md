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

