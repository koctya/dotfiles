## Embedding Cramp in a Rails App

So I have an application that would work great with [websockets](http://websockets.org/) because I don't want to be doing client polling. Rails doesn't deal with this right now, but [Cramp](https://github.com/lifo/cramp) does (cramp is a young web framework built on top of EventMachine). I know, I know, Node.js right? But I've already deployed on [Heroku](http://www.heroku.com/) and they aren't taking new participants for their Node.js beta, so I'm going to have to make it work.

Now, Cramp is indeed a Rack-based framework (mostly, sometimes not compliant), so theoretically I should be able to do this, and if it works out you'll have this post to help you along the way (using Rails 3.0, BTW).

First, I added Cramp to my gemfile (gem "cramp") and tried to bundle install it. Failure. The current cramp gem depends on arel (= 0.3.3), and Rails 3 of course need arel 1.1.0.

To fix that, I tried loading edge cramp into my app by using the git repo in my gemfile:

    gem "cramp",:git=>'git://github.com/lifo/cramp.git'

So far so good, at least the bundle installed correctly.

Before going any farther, I also added "thin" to my gemfile to use as my webserver in development, because in the Cramp documentation they point out that Cramp only works with Thin or Rainbows!.

Now, to get a cramp application running. I saw a great Screencast by Ryan Bates about Routing with Rack, so that's the approach I'm going to take using the "Hello World" example from this blogpost (**IMPORTANT**: Edge cramp does not use "Cramp::Controller::Action" anymore like in that blog post, Action is directly under Cramp now). To clarify, I'm dropping the following class into the lib directory:

    class ChatAction < Cramp::Action
      on_start :send_hello_world
    
      def send_hello_world
        render "Hello World"
        finish
      end
    end
    And then tried to route a path to it (routes.rb:( 
    MyApp::Application.routes.draw do
      match "/chat"=>ChatAction
    end

Starting up the server, I got a failure due to an uninitialized constant (It doesn't know about my ChatAction yet). I had to think about the right place to load it, because I haven't really traced the rails startup sequence before. Looking in "application.rb", Bundler loads all it's gems after loading up rails, so I decided to drop in my requirement right after that (load all bundler gems, than load my Cramp application, then start with the rails app config:( 

    require File.expand_path('../boot', __FILE__)

    require 'rails/all'
    
    Bundler.require:)default, Rails.env) if defined?(Bundler)
    require "lib/chat_action"
    
    module MyApp
      class Application < Rails::Application
        config.autoload_paths += %W( #{config.root}/extras )
        
        config.encoding = "utf-8"
    
        config.filter_parameters += [:password]
      end
    end
That seemed to work; at least everything booted without any more errors when I did this from the application home directory:
    rails server thin

and when I traveled to "localhost:3000/chat", I saw my "Hello World" render as expected.

So there you have it, how to get a cramp application running in your Rails 3 application (in the patented "Stumble your way through" methodology). Now to actually make it do something useful!

### Part II

After my last post on getting "Hello World" running on Cramp alongside a full rails application, I thought I'd continue to catalogue my progress on actually getting a websockets action running and doing a real data push back to the client.

First things first, the blog post by Pratik that introduces the concept is invaluable: http://m.onkey.org/2010/1/15/websockets-made-easy-with-cramp.

Following the directions there, I created an initializer (config/initializers/cramp_server.rb for cramp and included the following:

    Cramp::Websocket.backend = :thin

Notice that this isn't quite the same as the blog post, because I'm using edge cramp, and it's been refactored to remove the "Controller" module.

Anyway, rebooting the server everything still worked, so the next step was to rebuild my controller as a websockets aware rack application.

    class ChatAction < Cramp::Websocket
      on_data :received_data
    
      def received_data(data)
        render "Got your #{data}"
      end
    end

Which did indeed startup and respond to data requests from the client with an echo. Nice!

However, in order to support IE users, it would be necessary to use flash sockets, and although it's not that hard to do, I'm already getting uncomfortable with the number of things that are new to me in this app. So, as a responsible design decision, I'm planning on just using Cramp for long-polling for the time being until better websockets support is available across all the major browsers. 

Thanks Pratik for such a cool framework!