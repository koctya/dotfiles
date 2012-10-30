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

## Unobtrusive JavaScript

Rails 3 now implements all of its JavaScript Helper functionality (AJAX submits, confirmation prompts, etc) unobtrusively by adding the following HTML 5 custom attributes to HTML elements.

- data-method – the REST method to use in form submissions.
- data-confirm – the confirmation message to use before performing some action.
- data-remote – if true, submit via AJAX.
- data-disable-with – disables form elements during a form submission

Rails 3 makes it easy to convert any form to AJAX. First, open your _form.html.erb partial in app/views/posts, and change the first line from:

      <%= form_for(@post) do |f| %>
to

        <%= form_for(@post, :remote => true) do |f| %>

The attribute is data-remote="true", and the Rails UJS JavaScript binds to any forms with that attribute and submits them via AJAX instead of a traditional POST.

The most common way of handling a return from an AJAX call is through the use of JavaScript ERB files. These work exactly like your normal ERB files, but contain JavaScript code instead of HTML. Let’s try it out.
The first thing we need to do is to tell our controller how to respond to AJAX requests. In posts_controller.rb (app/controllers) we can tell our controller to respond to an AJAX request by adding

    format.js

in each respond_to block that we are going to call via AJAX. For example, we could update the create action to look like this:

    def create
        @post = Post.new(params[:post])

        respond_to do |format|
          if @post.save
            format.html { redirect_to(@post, :notice => 'Post created.') }
            format.js
          else
            format.html { render :action => "new" }
            format.js
          end
        end
    end

Because we didn’t specify any options in the respond_to block, Rails will respond to JavaScript requests by loading a .js ERB with the same name as the controller action (create.js.erb, in this case).

Now that our controller knows how to handle AJAX calls, we need to create our views. For the current example, add create.js.erb in your app/views/posts directory. This file will be rendered and the JavaScript inside will be executed when the call finishes. For now, we’ll simply overwrite the form tag with the title and contents of the blog post:

    $('body').html("<h1><%= escape_javaScript(@post.title) %></h1>").append("<%= escape_javaScript(@post.content) %>");

#### AJAX Callbacks Using Custom JavaScript Events
Each Rails UJS implementation also provides another way to add callbacks to our AJAX calls – custom JavaScript events. Let’s look at another example. On our Posts index view `(http://localhost:3000/posts/)`, we can see that each post can be deleted via a delete link.

Let’s AJAXify our link by adding :remote=>true and additionally giving it a CSS class so we can easily find this POST using a CSS selector.

    <td><%= link_to 'Destroy', post, :confirm => 'Are you sure?', :method => :delete, :remote=>true, :class=>'delete_post' %></td>

Which produces the following output:

    <td><a href="/posts/2" class="delete_post" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Destroy</a></td>

Each rails UJS AJAX call provides six custom events that can be attached to:

- ajax:before – right before ajax call
- ajax:loading – before ajax call, but after XmlHttpRequest object is created)
- ajax:success – successful ajax call
- ajax:failure – failed ajax call
- ajax:complete – completion of ajax call (after ajax:success and ajax:failure)
- ajax:after – after ajax call is sent (note: not after it returns)

In our case we’ll add an event listener to the ajax:success event on our delete links, and make the deleted post fade out rather than reloading the page. We’ll add the following JavaScript to our application.js file.

    $('.delete_post').bind('ajax:success', function() {
        $(this).closest('tr').fadeOut();
    });

We’ll also need to tell our posts_controller not to try to render a view after it finishes deleting the post.

    def destroy
      @post = Post.find(params[:id])
      @post.destroy

      respond_to do |format|
        format.html { redirect_to(posts_url) }
        format.js   { render :nothing => true }
      end

Now when we delete a Post it will gradually fade out.

### UTILIZING JQUERY

##### Remote forms

    form_for(@foo, :remote => true)

The “remote” paramter makes it a UJS form.

##### Remote links

    link_to(“My delete link”, “/delete/me“, data-method” => “delete”, “data-confirm” => “Are you sure?”)

The “data-“ params make it a UJS link.

#### The controller

No more RJS or old faux Prototype helpers. Now instead all you need to do in the controller is include the respond method to handle the xhr request.

    def create
        @foo = Bar.new(params[:zook])
        respond_to do |format|
            if @foo.save
                format.js {} # this handles the xhr request
                format.html # for rendering regular html
            end
        end
    end

The line for format.js handles the xhr request telling the app to render the view “create.js.erb.” So if you don’t already have the that file, create it now as the next step is to write some custom JavaScript.

#### The JavaScript

This is where the magic and customization comes in with the new Rails 3 UJS setup. Here you can write any custom Javascript to handle the callback methods with what the server returns.

Handling the callto

The rails.js file only contains the ability to perform on what to do when you throw AJAX methods to it such as the standard beforeSend, success, complete, or error. This way you can write any custom functions to interact with these callbacks. Here is a base structure of how to handle just that:

    $(“#my_remote_form”)
        .bind("ajax:beforeSend", function(){
            // Things to do before sending
        })
        .bind(“ajax:complete”, function(){
            // Things to do after the ajax is sent
        })
        .bind(“ajax:success”, function(){
            // Things to do when it’s a successful call
        })
        .bind("ajax:beforeSend", function(){
            // Things to do for an error
        });

The beforeSend action is great for letting the user know that something is happening. This can be done by changing the value of the submit button or adding a nice AJAX spinner graphic.

Handling the server callback

So the object was successfully saved to the database, now let’s take the data returned and append it to the DOM with an animation signifier.

    $(“#foo_list”).prepend(“<%=escape_javascript(render :partial=>’foo/bar_item’) %>");
    $(“#foo_list”).effect(“bounce”, { times:3 }, 300);

### [RGB Color Values](http://www.htmlhelp.com/cgi-bin/color.cgi?rgb=7FFFD4)

The following color names may safely be used with the FONT element and in a Cascading Style Sheet: aqua, black, blue, fuchsia, gray, green, lime, maroon, navy, olive, purple, red, silver, teal, white, and yellow.

## 85-yaml-configuration

> I find this configuration very useful as well. Further, I prefer to add a defaults section to the YAML config file, and allow let the other sections to inherit from that.

    yaml
    defaults: &defaults
      email: info@example.com

    development:
      <<: *defaults
      email: me@example.com

    test:
      <<: *defaults
      email: test@example.com

    staging:
      <<: *defaults

    production:
      <<: *defaults


