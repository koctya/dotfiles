# Ruby notes

## Gemfile trick for github repositories
Tired of writing long git paths to github repositories in Gemfile? Then you will find this useful. When the repository you need is public, you can use :github shortland instead of :git. And just specify github username and repository name separated by slash.

If repository name and username are the same, you can drop one:

    gem "rails", :github => "rails/rails"
    gem "rails", :github => "rails"

Are both equivalent to:

    gem "rails", :git => "git://github.com/rails/rails.git"

I wonder, how didn’t we enjoy this all the time? :)


## Bundler
#### [bundle open](http://blog.jerodsanto.net/2012/07/my-favorite-bundler-feature/?utm_source=rubyweekly&utm_medium=email)
Having used Bundler long enough to take its dependency management feature for granted (snark), I've come to know and love another feature of Bundler: `bundle open`

What does `open` do? It opens a bundled gem in your editor. Simple as that.

Want to toss some debug output inside an ActiveRecord query chain?

     bundle open activerecord

Would it just be easier to throw a `binding.pry` right inside Mongoid's call chain? (Pro tip: yes, yes it would)

      bundle open mongoid

`bundle` open reduces the friction of diving into my dependencies, which means I do it sooner and more often.

### How can I use Capistrano with Bundler? (via @smathy)

You can add `require 'bundler/capistrano'` to the top of your deploy.rb. This adds the bundle install task to run after every deployment. By default this runs a bundle install with the –deployment and –quiet flags as well as without the development and test groups. It installs the bundle to shared/bundle. You can override these defaults by setting any of these in your deploy.rb.

    set :bundle_gemfile,  "Gemfile"
    set :bundle_dir,      File.join(fetch(:shared_path), 'bundle')
    set :bundle_flags,    "--deployment --quiet"
    set :bundle_without,  [:development, :test]
    set :bundle_cmd,      "bundle" # e.g. "/opt/ruby/bin/bundle"
    set :bundle_roles,    #{role_default} # e.g. [:app, :batch]

##### I’m interested in some examples for ‘bundle pack.’ I find this command useful to deploy to machines off the network. (via @hoxworth)

Simple Example:
    bundle pack && git add vendor/cache && git commit -am “Packed gems” && git push && cap deploy

You can use this as a drop in replacement for vendor/gems, with the added benefit of knowing that even gems depended on will be consistent across platforms. Keep in mind this doesn’t work with gems from git yet, though.

### Traversing Directories with Ruby

If you want to shove filenames of all files in a directory into an array, do:

   # (absolute path)
   files = Dir["/Users/jerod/src/**"]
   # (relative path)
   files = Dir[File.expand_path("~/src") + "/**"]
   # (in ENV["PWD"], aka current directory)
   files = Dir["**"]

If you want to shove filenames of all files in a directory recursively into an array, do:

   # (absolute path)
   files = Dir["/Users/jerod/src/**/**"]
   # (relative path)
   files = Dir[File.expand_path("~/src") + "/**/**"]
   # (in ENV["PWD"], aka current directory)
   files = Dir["**/**"]

It doesn’t get much easier than that.

### A simple Ruby method to send email
17 Feb 2009
I have tried many different Ruby mailers and they all have their problems. The Pony gem by Adam Wiggins is right up my alley but even that has given me a hard time sending emails. Plus, sometimes you just don't want your little Ruby script having to require rubygems.

I always end up reverting to a simple method I wrote awhile back and it just works. Feel free to use it and adjust to your needs:

    require 'net/smtp'

    def send_email(to,opts={})
      opts[:server]      ||= 'localhost'
      opts[:from]        ||= 'email@example.com'
      opts[:from_alias]  ||= 'Example Emailer'
      opts[:subject]     ||= "You need to see this"
      opts[:body]        ||= "Important stuff!"

      msg = <<END_OF_MESSAGE
    From: #{opts[:from_alias]} <#{opts[:from]}>
    To: <#{to}>
    Subject: #{opts[:subject]}

    #{opts[:body]}
    END_OF_MESSAGE

      Net::SMTP.start(opts[:server]) do |smtp|
        smtp.send_message msg, opts[:from], to
      end
    end

Everything but the to argument is optional. You can invoke the method like so:

    send_email "admnistrator@example.com", :body => "This was easy to send"

### Ruby Abort

A lot of people end up writing Ruby methods that looks something like this:

    def stop_error(message)
      puts "ERROR: #{message}"
      exit(1)
    end

Which they call in their app like so:

    stop_error "Oh noes, file doesn't exist!" unless File.exist?(file)

I used to write that method a lot too. Did you know Ruby has a built-in method that provides just what we're all looking for?

`Kernel::abort`

So, stop writing your own little method and just abort it:

    abort "Oh noes, file doesn't exist!" unless File.exist?(file)

### Fluentd

Install
    gem install fluentd

Find plugins;
    gem search -rd fluent-plugin

#### Fluent plugins

fluent-plugin-amqp (0.0.0)
    Author: Hiromi Ishii
    Homepage: http://github.com/konn/fluent-plugin-amqp

    AMQP input/output plugin or fluentd

fluent-plugin-hoop (0.1.4)
    Author: TAGOMORI Satoshi
    Homepage: https://github.com/fluent/fluent-plugin-hoop

    Cloudera Hoop (Hadoop HDFS HTTP Proxy) plugin for Fluent event
    collector
fluent-plugin-http-enhanced (0.0.4)
    Author: Abhishek Parolkar
    Homepage: https://github.com/parolkar/fluent-plugin-http-enhanced

    Enhanced HTTP input plugin for Fluent event collector
fluent-plugin-kestrel (0.2.2)
    Author: Junichiro Takagi
    Homepage: http://github.com/tjun/fluent-plugin-kestrel

    fluentd input/output plugin for kestrel.
fluent-plugin-mongo (0.6.7)
    Author: Masahiro Nakagawa
    Homepage: https://github.com/fluent/fluent-plugin-mongo

    MongoDB plugin for Fluent event collector
fluent-plugin-pghstore (0.1.2)
    Author: WAKAYAMA Shirou
    Rubyforge: http://rubyforge.org/projects/fluent-plugin-pghstore
    Homepage: https://github.com/shirou/fluent-plugin-pghstore

    Output to PostgreSQL database which has a hstore extension
fluent-plugin-resque (0.2.1)
    Author: Yuichi Tateno
    Homepage: https://github.com/hotchpotch/fluent-plugin-resque

    Resque enqueue plugin
fluent-plugin-s3 (0.2.2)
    Author: Sadayuki Furuhashi
    Homepage: https://github.com/fluent/fluent-plugin-s3

    Amazon S3 output plugin for Fluent event collector

fluent-plugin-solr (0.1.1)
    Author: Nobutaka Nakazawa
    Homepage: http://github.com/btigit/fluent-plugin-solr

    Solr output plugin for Fluent event collector

## Colorful Ruby Code In HTML Using CodeRay

#### Install the CodeRay gem

First we need to install the CodeRay gem.

      gem install coderay

Colorize That Code

The CodeRay gem is very feature rich, but here is a simple out-the-box example that will colorize our code for syntax highlighting...

    ruby -e '
         require "coderay";
         filename = "app/controllers/home_controller.rb";
         print CodeRay.scan_file(filename).div
    '

This example will output HTML with inline CSS. This is a good quick and dirty way to get to colorized code, but your front-end CSS person, who likes clean HTML, will probably hate you. Replacing the ".div" with ".html" will not include the CSS and it will be up to you to provide the style for the CSS classes.

Take It Out Of The Oven

Here is what the colorized code will look like on your blog, webpage or presentation...

`class HomeController < ApplicationController

  FEATURE_ICONS_DIRECTORY = File.join::(Rails.root, "public/img/feature-icons")

  def index
    # Find all the images in the "feature-icons" directory, strip off
    # the directory and extension, to just leave a list of icon names
    @feature_names =
      Dir.entries(File.join(FEATURE_ICONS_DIRECTORY)).
        reject { |f| ! f.end_with? ".png" }.
        map    { |f| f.split(".")[0] }.
        sort
  end
end`

And there it is. Not much more to say about that other than how easy it was. Although it was easy the CodeRay gem is very rich.

####Resources

[CodeRay Official Website](http://coderay.rubychan.de/)
[CodeRay on GitHub](https://github.com/rubychan/coderay)
[More CodeRay examples (1470 of them!)](http://coderay.rubychan.de/rays)

## misc
`module PlatformDetection
  def mri?
    !defined?(RUBY_ENGINE) || (defined?(RUBY_ENGINE) && ("ruby" == RUBY_ENGINE))
  end

  def rubinius?
    defined?(RUBY_ENGINE) && (RUBY_ENGINE == 'rbx')
  end
end
`

`spec/spec_helper`

`$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'bundler'
Bundler.setup(:default, :test)
`
