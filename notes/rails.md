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
