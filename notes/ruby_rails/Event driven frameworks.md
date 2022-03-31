# Event driven frameworks

## [Goliath](http://postrank-labs.github.com/goliath/doc/index.html) - [on Github](https://github.com/postrank-labs/goliath)
Goliath is an open source version of the non-blocking (asynchronous) Ruby web server framework powering PostRank. It is a lightweight framework designed to meet the following goals: bare metal performance, Rack API and middleware support, simple configuration, fully asynchronous processing, and readable and maintainable code (read: no callbacks).
#### Getting Started: Hello World

	require 'goliath'
	
	class Hello < Goliath::API
	  def response(env)
	    [200, {}, "Hello World"]
	  end
	end
	
	> ruby hello.rb -sv
	> [97570:INFO] 2011-02-15 00:33:51 :: Starting server on 0.0.0.0:9000 in development mode. Watch out for stones.

#### See
- [Stage left: Enter Goliath](http://everburning.com/news/stage-left-enter-goliath/)
- [Async Rails 3.1 stack demo](https://github.com/igrigorik/async-rails)
- [Rails Performance Needs an Overhaul](http://www.igvita.com/2010/06/07/rails-performance-needs-an-overhaul/) By Ilya Grigorik on June 07, 2010
- [Untangling Evented Code with Ruby Fibers](http://www.igvita.com/2010/03/22/untangling-evented-code-with-ruby-fibers/)
- [Fibers & Cooperative Scheduling in Ruby](http://www.igvita.com/2009/05/13/fibers-cooperative-scheduling-in-ruby/)
- [Driving Google Chrome via WebSocket API](http://www.igvita.com/2012/04/09/driving-google-chrome-via-websocket-api/)
- [Momentarily](https://github.com/eatenbyagrue/momentarily) - Momentarily was created to allow Rails developers to speed up their applications for end users. Momentarily gives developers the ability to quickly and safely move slow operations into a thread and out of the request chain so user experience is not impacted by operations like sending emails, updating web services or database operations. Momentarily is a wrapper around EventMachine with Rails considerations baked in. 

## [Cramp](http://cramp.in/) 
Cramp is a fully asynchronous real-time web application framework in Ruby. It is built on top of [EventMachine](http://rubyeventmachine.com/) and primarily designed for working with larger number of open connections and providing full-duplex bi-directional communication.

### Features

- Lightweight, minimal and able to handle thousands of open connections simultaneously
- Built in support for HTML5 technologies: **WebSockets** and **Server-Sent Events** ( EventSource )
- Easy peasy Streaming APIs
- Allows Ruby 1.9 + **Fibers** to prevent asynchronous callbacks spaghetti
- Seamless **Active Record** integration
- Rack Middlewares support + [Rainbows!](http://rainbows.rubyforge.org/) and [Thin](http://code.macournoyer.com/thin) web servers

### Getting Started

Ruby 1.9.2+ is the preferred version of Ruby for running Cramp. Installation process is quite straight forward:

	$ gem install cramp

And here’s the obligatory “Hello World”:

	# hello_world.ru
	require "rubygems"
	require 'cramp'
	
	class HomeAction < Cramp::Action
	  def start
	    render "Hello World"
	    finish
	  end
	end
	
	# thin --timeout 0 -R hello_world.ru start
	run HomeAction

Cramp ships with an application generator, which is great for getting off the ground.

	$ cramp new realapp

### [EventMachine with Rails](http://www.hiringthing.com/2011/11/04/eventmachine-with-rails.html)

The alternative is the [AMQP gem](https://github.com/ruby-amqp/amqp), which is asychronous, but requires EventMachine to work correctly.

	require 'amqp'
	module HiringThingEM
	  def self.start
	    if defined?(PhusionPassenger)
	      PhusionPassenger.on_event(:starting_worker_process) do |forked|
	      # for passenger, we need to avoid orphaned threads
	        if forked && EM.reactor_running?
	          EM.stop
	        end
	        Thread.new {
	          EM.run do
	             AMQP.channel ||= AMQP::Channel.new(AMQP.connect(:host=> Q_SERVER, :user=> Q_USER, :pass => Q_PASS, :vhost => Q_VHOST ))
	          end
	        }
	        die_gracefully_on_signal
	      end
	    else
	      # faciliates debugging
	      Thread.abort_on_exception = true
	      # just spawn a thread and start it up
	        Thread.new {
	          EM.run do
	             AMQP.channel ||= AMQP::Channel.new(AMQP.connect(:host=> Q_SERVER, :user=> Q_USER, :pass => Q_PASS, :vhost => Q_VHOST ))
	          end
	        } unless defined?(Thin)
	        # Thin is built on EventMachine, doesn't need this thread
	    end
	  end
	
	  def self.die_gracefully_on_signal
	    Signal.trap("INT")  { EM.stop }
	    Signal.trap("TERM") { EM.stop }
	  end
	end
	
	HiringThingEM.start

### [Raking and Testing with EventMachine](http://blog.carbonfive.com/2011/02/03/raking-and-testing-with-eventmachine/)
I have been getting more and more interested in high-performance Ruby apps, and in [EventMachine](http://rubyeventmachine.com/) in particular. First of all, super props to Aman Gupta for EM, and to some other Ruby devs out there who have been writing libraries and drivers on top if it, such as [Ilya Grigorik](https://github.com/igrigorik), and Carbon Five’s own Mike Perham.

However one area that has not gotten a lot of attention within the EventMachine world is that of testing and tools support. It would be ideal for evented codebases if all tests and all rakes were automatically run inside an EventMachine reactor. I realize that many of the EM-enabled libraries out there, like mysql2, work whether they are in a reactor or not, so this may seem unnecessary. But this means that your tests are exercising a different code path than your production app, which is a bad idea.

So how can we get our tools running within EventMachine?

### Monkey-patching to the rescue

I am using rake, rspec and cucumber in an EM-enabled project, and I monkey-patched each of these gems within my project to run inside a reactor. The strategy for each gem is very similar: I look for the first method called within the gem in question that is executed after the project files have been loaded, and I override it, wrapping it in a reactor.

Let’s take a look at how this works for Rake:

#### Rake

*lib/tasks/em.rake*

	module Rake
	  class Application
	 
	    alias_method :top_level_alias, :top_level
	 
	    def top_level
	      EM.synchrony do
	        top_level_alias
	        EM.stop
	      end
	    end
	 
	  end
	end
In this case, I override *Rake::Application.top_level*. I first alias it to top_level_alias, and then I wrap a call to that aliased method with a call to EM.synchrony.[1] And of course I stop the reactor in the end of my block.

For RSpec, the code is a little more complex, but the idea is the same.

#### RSpec

*spec/spec_helper.rb*

	module RSpec
	  module Core
	    class ExampleGroup
	 
	      class << self
	        alias_method :run_alias, :run
	 
	        def run(reporter)
	          if EM.reactor_running?
	            run_alias reporter
	          else
	            out = nil
	            EM.synchrony do
	              out = run_alias reporter
	              EM.stop
	            end
	            out
	          end
	        end
	      end
	 
	    end
	  end
	end
I would like to call a method that wraps the entire test suite, but the best I can do is a method wrapping a single example group. This means that I start and stop a reactor for each spec file in my project. This is not ideal, but it works just fine.

Also notice that I check whether or not the reactor is running. Because of the recursive way RSpec works, we are often already in a reactor loop when we wind up calling this method.

Cucumber is straightforward, just like Rake.

#### Cucumber

*features/support/em.rb*

	module Cucumber
	  module Ast
	    class TreeWalker
	      alias_method :visit_features_alias, :visit_features
	 
	      def visit_features(features)
	        EM.synchrony do
	          visit_features_alias features
	          EM.stop
	        end
	      end
	    end
	  end
	end
	Conclusion

My hope is that each of these gems (and the other similar ones out there) will add the ability to run themselves inside an EM reactor. I see this as a configuration option, much the way ‘-drb’ is used by many gems to enable Spork. It is my plan to fork these gems and implement it myself, so the gem owners out there should expect a pull request some time soon.


### Footnotes

[1] If you don’t already know, EM.synchrony is part of Ilya’s excellent [em-synchrony gem](https://github.com/igrigorik/em-synchrony). It elegantly starts a reactor within a Ruby Fiber (which also means you need to be using Ruby 1.9).
