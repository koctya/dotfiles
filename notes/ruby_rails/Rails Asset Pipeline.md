# Rails Asset Pipeline

## [Ajax and jQuery Basics for Rails 3.1 and later](http://notes.rehali.com/?p=97)
Posted on February 4, 2012 by rehali

Modified for Haml, Sass, Coffescript

#### Introduction

Although ruby and rails are great for the server side, they cannot do much to improve the experience for the user in the browser. Rails takes advantage of two technologies to improve the user experience in the browser:

- ajax – allows you to use javascript to render partial areas within a web page. In general the response seems more fluid because the whole page is not being redrawn.
- jQuery – is a library for simplifying interaction with the DOM (the html Document Object Model) using javascript

JQuery itself has a set of additional libraries or plugins to provide enhanced browser features such as:

-  effects (hide/show/fade/slide)
-  datepicker
-  data tables
-  tabbed sections
-  accordions
-  etc..

In this first look at Ajax and jQuery we are going to build a simple blog. We’ll create it first as a standard Blog and then we’ll use Ajax and jQuery to improve the look and feel.

#### Step 1 Build our new rails app

The intro steps:

- create the new rails app
- install all the gems

. 

    $ rails new ajax_blog -T
    create
    create README.rdoc
    create Rakefile
    create config.ru
    create .gitignore
    create Gemfile
    create app
    create app/assets/images/rails.png
    create app/assets/javascripts/application.js
    create app/assets/stylesheets/application.css
    create app/controllers/application_controller.rb
    ....
    $ cd ajax_blog
    $ bundle install --binstubs
    Using rake (0.9.2.2)
    Using i18n (0.6.0)
    Using multi_json (1.0.4)
    Using activesupport (3.2.1)
    Using builder (3.0.0)
    Using activemodel (3.2.1)
    Using erubis (2.7.0)
    Using journey (1.0.1)
    ....

edit Gem file, adding;

      gem 'jquery-ui-rails'
      gem 'jquery-ui-themes'
      gem 'jquery-datatables-rails'
      gem 'underscore'
      gem 'compass'
      gem 'zurb-foundation'

to the assets group, and

    gem 'coffee-rails', '~> 3.2.1'    # moved out of assets group to use in views.
    gem 'haml-rails'
    gem 'haml-coderay'
    gem 'coffee-filter'
    gem 'therubyracer'
    
    group :development, :test do
      gem 'pry-rails'
      gem 'pry-nav'
      gem 'rspec-rails'
      gem 'yard'
      gem 'yard-cucumber'
    end
    
    group :test do
      gem 'cucumber-rails'
      gem 'gherkin'
      gem 'database_cleaner'
      gem 'simplecov'
      gem "rails_best_practices"
    end

Run bundle to install the gems;

Now create a simple scaffold for our blog which will contain a collection of posts which have:

- title
- email
- contents

?

    $ rails g scaffold post title:string email:string content:text
    invoke active_record
    create db/migrate/20120203062425_create_posts.rb
    create app/models/post.rb
    invoke test_unit
    create test/unit/post_test.rb
    create test/fixtures/posts.yml
    route resources :posts
    .....
    $ bin/rake db:migrate
    = CreatePosts: migrating ====================================================
    -- create_table:)posts)
    -> 0.0008s
    == CreatePosts: migrated (0.0009s) ===========================================
    $

We can now run the application to see our basic “scaffold” built rails app.

    $ rails s
    =>; Booting WEBrick
    =>; Rails 3.2.1 application starting in development on http://0.0.0.0:3000
    =>; Call with -d to detach
    =>; Ctrl-C to shutdown server
    [2012-02-03 16:36:30] INFO WEBrick 1.3.1
    [2012-02-03 16:36:30] INFO ruby 1.9.2 (2011-07-09) [i686-linux]
    [2012-02-03 16:36:30] INFO WEBrick::HTTPServer#start: pid=28495 port=3000

We might just set a default root for our application. Edit the config/routes.rb file to add the line

?

    root :to =>; "posts#index"

And remember to delete the  public/index.html.

So, here’s our default index page
![](images/ajax_blog/scaffold_index.png)


and our default new post page…
![](images/ajax_blog/scaffold_new.png)


and back to the index when we have added a post!
![](images/ajax_blog/scaffold_post.png)


### Step 2 Tidy up the app

We’re going to combine the index and new post pages into a single page. In fact all of the user interface action will appear on the index page. We’ll use partials to do this:

our original index page (straight from the scaffold:(

    %h1 Listing posts
    
    %table
      %tr
        %th Title
        %th Email
        %th Content
        %th
        %th
        %th
      - @posts.each do |post|
        %tr
          %td= post.title
          %td= post.email
          %td= post.content
          %td= link_to 'Show', post
          %td= link_to 'Edit', edit_post_path(post)
          %td= link_to 'Destroy', post, :confirm => 'Are you sure?', :method => :delete
    
    %br

    = link_to 'New Post', new_post_path

On our revised index page we’re going to show both the new/edit form and also the list of previous posts. We’ll use 2 partials for this, and we’ll render the posts as an unordered list:

The index.html.haml page (note that @posts.reverse will show the posts with most recent first:

    %h1 Posts
    
    #post_form
      = render 'form'
    
    %ul#posts
      = render :partial => @posts.reverse

The _form.html.erb page, hasn’t changed from that generated by the scaffold:

    = form_for @post do |f|
      -if @post.errors.any?
        #error_explanation
          %h2= "#{pluralize(@post.errors.count, "error")} prohibited this post from being saved:"
          %ul
            - @post.errors.full_messages.each do |msg|
              %li= msg
      .field
        = f.label :title
        = f.text_field :title
      .field
        = f.label :email
        = f.text_field :email
      .field
        = f.label :content
        = f.text_area :content
      .actions
        = f.submit 'Create Post'

The _post.html.erb page will render each post in a li tag:

    = content_tag_for(:li, post) do
      %p.title= "#{post.title} - [#{post.email}]"
      %p.content= post.content
      %span.posted_at
        Posted at #{time_ago_in_words(post.created_at)} ago.
        = link_to 'Delete', post, :confirm => 'Are you sure?', :method => :delete

We’ll need to make a few adjustments to the `posts_controller.rb` as well:

For the `index` method we add a `Post.new` so that the form has a new empty post to work with.
We can remove the `new` and `show` methods because our single page is now showing the posts.
In the `create` method we redirect back to the index on a successful save, using `redirect_to posts_url`.

    def index
      @posts = Post.all
      @post = Post.new  # added
     
      respond_to do |format|
        format.html
      end
    end
     
    def create
      @post = Post.new(params[:post])
     
      respond_to do |format|
        if @post.save
          format.html { redirect_to posts_url, notice: 'Post was successfully created.' } #changed
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "index" } #changed
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end

We’ve applied a simple stylesheet `posts.css.scss`:

    // Place all the styles related to the posts controller here.
    // They will automatically be included in application.css.
    // You can use Sass (SCSS) here: http://sass-lang.com/
     
    html, body
      font-family: Times
      font-size: 12px
    
    textarea
      font-family: Times
      font-size: 12px
      width: 500px
      height: 100px
      padding-bottom: 8px
    
    .textfield
      font-family: Times
      font-size: 14px
      width: 300px
      padding-bottom: 8px
      border: 1px solid black
    
    #posts ul
      margin: 0
      padding: 0
    
    #posts li
      margin-left: -30pt
      margin-bottom: 16px
      padding: 8px
      list-style: none
      border: 1px solid #ccc
    
    #posts p
      margin: 0
    
    #posts .title
      font-size: 13px
      font-weight: bold
    
    #posts .content
      font-size: 12px
      margin-top: 10px
      margin-bottom: 10px
    
    .posted_at
      font-size: 8pt
      text-decoration: italic
      margin-bottom: 8px
    
    #timer
      font-size: 8pt
      text-decoration: italic


The new page looks like:
![](images/ajax_blog/posts_stage2.png)


### Step 3 – Use Ajax to only render the changes

We will need to modify the form and any links so that they use `:remote => true` which signals to Rails that we want to use Ajax.

We will also need to create some javascript views (`create.js.erb` and `destroy.js.erb`) to render the changes and send them back to the index page.

In `_form.html.erb` we add` :remote => true`

    = form_for @post, :remote => true do |f| 

In `_post.html.erb` we add `:remote => true` to the delete link:

    = link_to 'Delete', post, :confirm => 'Are you sure?', :method => :delete, :remote => true

In the posts_controller.rb we provide a respond_to :js for the create method:

    if @post.save
      format.html { redirect_to posts_url, notice: 'Post was successfully created.' }
      format.json { render json: @post, status: :created, location: @post }
      format.js  #added
    else

and a `respond_to :js` for the `delete` method.

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
      format.js #added
    end

Finally we create a `create.js.erb` javascript view template:

- `$(‘#posts’)` uses jQuery syntax to locate the element with `id=”posts”` and then renders the new post into it using prepend to put it first in the list – escape_javascript escapes carriage returns and single and double quotes for JavaScript segments. Also available through the alias `j()`.
- `#post_form > form` looks for the child element form within `#post_form`, the [0] array index looks for the first matching form, and `reset()` will reset the values in the form.

        $('#posts').prepend('<%= escape_javascript(render(@post)) %>')
        $('#post_form > form')[0].reset()

and a `destroy.js.erb` javascript view template :

- dom_id(@post) returns the “id” of the specified post. jQuery can then use this selector to remove the item.


    $('#<%= dom_id(@post) %>').remove();

Our latest version looks like:
![](images/ajax_blog/posts_stage3.png)


Note: We’ve added an extra line to display the time the index page was last rendered. As you add and delete posts the time will not change, since we are only rendering the changes into the page.

    <h1>Posts</h1>
    <div id="timer">Rendered at: <%= Time.now %></div>  
     
    <div id="post_form">
      <%= render 'form' %>
    </div>
     
    <ul id="posts">
      <%= render :partial => @posts.reverse %>
    </ul>

### Stage 4 – using some jQuery effects

Although we’re now using Ajax to improve the interaction, posts appear and disappear very quickly, meaning that it’s not always evident to the user what has happened. We can use some jQuery effects to provide some feedback to the user.

To include jQuery effects you need to add the jquery-ui-rails gem.

    group :assets do
      gem 'jquery-ui-rails'
    end

To require all jQuery UI modules, add the following to your application.js:

    //= require jquery.ui.all
    //= require underscore

Also add the jQuery UI CSS to your application.css:

     *= require jquery.ui.all

You can now modify your javascript views to provide some feedback to the user:

firstly – `create.js.erb`, we add the line showing the effect. Here `first()` retrieves the first matching element and for the effect we’re picking the type “highlight”, the color and mode, and also the time delay (2 seconds).

    $('#posts').prepend('<%= escape_javascript(render(@post)) %>')
    $('#posts > li').first().effect('highlight', {color: 'cyan', mode: 'show'}, 5000)
    $('#post_form > form')[0].reset()
    console?.log 'created; @post'

secondly – `destroy.js.erb`, we’re applying a similar effect with different color, mode and time delay.

    $('#<%= dom_id(@post) %>').effect('highlight', {color: 'red', mode: 'hide'}, 1200)
    # $('#<%= dom_id(@post) %>').remove();
    console?.log 'deleted #<%= dom_id(@post) %>'

The end result…

![](images/ajax_blog/posts_stage4.png)

Summary

In this post we’ve looked at how to render partial content in a page using Ajax and :remote => true on both forms and links. We’ve also looked at how to use jQuery to identify and work with content on a page. Finally we looked at using jquery-ui to apply effects to our page.

Coming up…, working with jQuery-UI

[working copy is available at https://rehali@github.com/rehali/simple-ajax-blog.git]

[This tutorial was based on a previous tutorial by Andrew Turner at http://tekn0t.net/ajax-example-with-rails-3-and-jquery]









# JQuery-UI css and images, and Rails Asset Pipeline

For Rails 3.1 (3.1.3 is the latest release as I write this).

If you have JQuery-UI CSS generated by the theme roller, say for the ‘cupertino’ theme. One option is exploding the contents a bit, put the `jquery-ui-1.8.16.custom.css` file directly at ./app/assets/stylesheets/jquery-ui-1.8.16.custom.css, and put the corresponding jquery-ui theme ./images subdir directly at `./app/assets/stylesheets/images.`  (Or ./vendor/assets or ./lib/assets). Now just include the .css file in your application.css, “ *= require jquery-ui-1.8.16.custom.css “.

If instead you really do want to leave the JQuery-UI theme source in it’s own subdir by itself, say at `./app/assets/stylesheets/jquery-ui/cupertino` (or ./vendor/assets or ./lib/assets), then you’ve got to add this to your config/application.rb, matching the file path you’ve chosen to put it at:

    initializer :after_append_asset_paths, 
                :group => :all, 
                :after => :append_assets_path do
       config.assets.paths.unshift Rails.root.join("app", "assets", "stylesheets", "jquery-ui", "cupertino").to_s
    end

Your JQuery-UI theme images will now work, both in standard development config, standard production, as well as other combinations of asset piepline configuration.  Works well as far as I can tell in Rails 3.1.3, probably will continue working in the future. (can put in ./vendor/assets or ./lib/assets  instead of ./app/assets, same thing).

For more info and a couple other options, read on.

###The problem

The jquery-rails gem, which is added to a new app’s Gemfile by default in rails 3.1, comes with JS for JQuery-UI.  You can include JQuery-UI JS just by adding this to your application.js:

    //= require jquery-ui

Okay, but what about the JQuery-UI theme, which is CSS and some images referenced by that CSS?  The jquery-rails README kind of unhelpfully suggests:

> In order to use the themed parts of jQuery UI, you will also need to supply your own theme CSS. See jqueryui.com for more information.

Okay, but if you do this the most straightforward way, you’ll find out it doesn’t work. I download a theme, say for the theme ‘cupertino’, and I get a zipfile `jquery-ui-1.8.16.custom.zip`.  Inside there, is a ./css directory.

Okay, I take this ./css directory and actually rename it into my app, say at: `./app/assets/stylesheets/jquery-ui`.  (Can put it in ./vendor/assets too, or even ./lib/assets, all will have the same outcome).

So now inside my local `./app/assets/stylesheets/jquery-ui`, I’ve got `./cupertino`, `./cupertino/jquery-ui-1.8.16.custom.css`, and `./cupertino/images`

So I go into my ./app/assets/application.css, and add:

    *= require jquery-ui/cupertino/jquery-ui-1.8.16.custom.css

Start up my app, with some JQuery-UI code activated, and everything works fine in standard ‘development’ mode configuration. But in ‘production’ mode, with pre-compiled assets, none of the JQuery-UI theme images show up. (Which in some cases degrades usably but not as aesthetic, in other cases is a usability problem like lack of a ‘close’ button on a dialog).

What happened? Well, when compiled under sprockets, the contents of jquery-ui-1.8.16.custom.css is actually combined into the application.css file, which lives at the URL (for an app mounted at host root URL:( `/assets/application.css`.   But that JQuery-UI CSS contains relative URLs to image assets, of the form `url(images/something.png)`

And relative to `/assets/application.css`, that means `/assets/images/something.png`.  But sprockets actually compiled the images to file path `./public/assets/jquery-ui/cupertino/images/something.png`, where it’ll be at url `/assets/jquery-ui/cupertino/images/something.png`  Not the right place for the CSS.

If I look around on the web for solutions to this, you get a lot of conflicting and confusing answers, perhaps because they were written for different versions of the asset pipeline (inc. some pre-release versions).  I’m not even going to link you to the various reddits, stackoverflows, etc, because it’s just too confusing and depressing. The most popular one seems to involve making symbolic links in your source. Come on really? Symbolic links, that tend to go wrong if you don’t do things perfectly when zipping up your source or copying it to another place or on Windows? I figured there’s got to be a better way.

In fact, I’m going to give you not just one alternate/better way, but four (count them, one, two, three, four) alternate/better ways.  Well, that’s kind of a lie, I’ll give you two better way that actually work with the asset pipeline, and two more that don’t use the pipeline for jquery-ui theme, but you can still use in your app that otherwise uses the pipeline.  For typical cases, any of em could work, but weird cases (say, wanting to have more than one theme available at runtime) each has trade-offs.

### One way that works with the pipeline, take apart the subdir structure

Just take the files out of the jquery-ui generated directory stucture, and  put `jquery-ui-1.8.16.custom.css` directly  at ./app/assets/stylesheets/jquery-ui-1.8.16.custom.css, and put the corresponding jquery-ui theme ./images subdir _directly_ at `./app/assets/stylesheets/images.`

(Or put em in ./vendor/assets or ./lib/assets, will work identically in any of those. Maybe vendor is best, I dunno).

Now in your application.css, just

     *= require jquery-ui-1.8.16.custom.css

Now the relative paths in the CSS will resolve correctly both with and without pre-compiled assets, as well as even with `config.assets.debug = false` in dev.

Great, that’s pretty simple. I have to admit I didn’t think of this until I had spent quite a bit of time figuring out the next way, which will work with whatever subdirectory structure you want. Hey, maybe you really want to keep the subdir structure to keep your jquery-ui theme stuff nicely segregated. Or maybe you just want to learn a bit more about how Rails and Sprockets work. Then read, on.

### Second way that works with the pipeline, whatever subdirs you want

So maybe you really still want to keep your jquery-ui theme all nicely grouped together in a subdir,  `./(app|vendor|lib)/assets/stylesheets/jquery-ui/themename`.  Just cause it’s tidier, or becuase you need multiple themes installed in your source (although that latter gets trickier).

First I thought, okay, well, maybe we can just add `./app/vendor/assets/stylesheets/themename`  to config.assets.paths in application.rb, now we’re telling sprockets to treat that as a ‘base’ dir, and compile the stuff (images in this case) in there directly to ./public/assets without the parent dirs, keeping the relative paths working.

Turns out I was on the right track, but that doesn’t work. Because  it turns out the order of paths matters to the Sprockets device that compiles assets. And Rails insists on adding ./(app|lib|vendor)/assets to the paths before anything you add yourself in config.assets.paths .  And Sprockets will then compile your stuff at that path, and when it sees a different subsequent path that also matches those same files, Sprockets is smart enough to know it already compiled that stuff from the previous path, and not compile it again.  So your addition to config.assets.paths of a subdir of one of the paths listed earlier essentially does nothing.

Turns out the place Rails insists on adding it’s own default paths first is in an append_assets_path initializer.    (Yes, despite the name “append_”, it actually prepends em with Array#unshift. Maybe it used to append but was changed to prepend to fix some other desired behavior?). Okay, great, the Rails 3.x initializer framework let’s us hook in right after Rails does this, to put what we want first in config.assets.paths instead.

Say we have our jquery-ui theme at `./vendor/assets/stylesheets/jquery-ui/cupertino`.  Add that path to the beginning of config.assets.paths, even before the stuff Rails prepended, by putting this in your config/application.rb:

    initializer :after_append_asset_paths, 
                :group => :all, 
                :after => :append_assets_path do
       config.assets.paths.unshift Rails.root.join("vendor", "assets", "stylesheets", "jquery-ui", "cupertino").to_s
    end

This works, to get the theme css’s relative URLs to images working,  in default (as installed by Rails) development mode asset config. It works in default production mode asset config, with precompiled assets.  It even works in development mode but with `config.assets.debug = false`. Each of these setups winds up with different ways of serving assets and potentially different path relationships between assets, but this works in every combo I tried. (Some of them probably work because config.assets.paths, depending on assets config, is sometimes used to create routing to assets too).

Will this keep working in the future? I dunno, I’m not technically using any internal API or anything, but I doing something not documented or popular, and counting on internal implementation not changing that much, the :append_assets_path initiailizer remaining there and named the same and used in the same way, etc. Guess it depends on how much Rails changes, like usual.

#### How the heck did I figure that out

I was not previously familiar with the inner workings of Sprockets or the Rails 3.1 asset pipeline. Instead, figuring that out took me about 5 hours of iteratively doing a bunch of this stuff:

- Looking at source code for both Rails and Sprockets in like 6 open tabs of github source, trying to understand how they are interacting where.
- Using github search function (wish it worked better), or grep’ing through checked out source to try and figure out where a particular method or module or class is defined. (Rails, why do you namespace classes in Rails source with ::Sprockets , fooling me into thinking I’d find em in Sprockets source? Couldn’t you have namespaced em Rails::Sprockets instead?)
- Using ruby-debug to investigate live source, and put breakpoints at Rails or Sprockets source lines to investigate em there. One reason to investigate is to figure out what the heck class a given variable is (Rails.application.assets anyone?). Another trick I like to do is drop into debug, call #freeze on an object, continue, and then wait for the stacktrace to figure out exactly who/where tried to modify that object next. (It is a travesty that ruby 1.9.3 does not work with ruby-debug, a travesty I say)
- Looking at the Rails [config](http://guides.rubyonrails.org/configuring.html) and [asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) guides to try and understand at least the big picture design.
- Googling for hints from other people, or sometimes just hints as to what source file a particular method was actually defined in when I was having trouble finding it.
- Wash, rinse, repeat, do these steps in a different order, go down blind alleys and realize that and backtrack in my investigation, etc.

Rails 3.x is really complicated code. Composed of multiple independent decoupled modules which interact with each other in complicated ways, occasionally even monkey-patching each other. (And Sprockets, would it kill you to add some one-two liner rdoc-style comments above your methods and classes, even non-public ones, telling the reader what they do?)

On the other hand, 4-6 hours ain’t that much time for getting to the bottom of fairly complicated functionality. And the solution I arrived at is fairly tidy, Rails 3.x is designed/factored pretty nicely these days to support surgical interventions (thanks Rails for just modifying config.assets.path once in an initiailizer instead of hard-coding it into the places Rails.application.assets is init’d and routes are init’d), and the 3.x initializer chain system is pretty sweet. (But Rails can’t decide whether to use strings or symbols for initializer names, it uses both, but you need to match the form used originally for the initializer :after or :before stuff. Grr.)

### Third way, why host the theme yourself at all?

If you are taking a stock JQuery-UI theme and not customizing it at all, did you know that the Google ajax/open source tools CDN hosts all the stock JQuery-UI themes? (Although it’s not documented well, they’re there).  Why host it yourself at all, just link to the Google CDN. Sure it’ll be one more browser request since you haven’t combined the jquery-ui CSS into your application.css with the pipeline, but just one more request, to the Google CDN which is presumably relatively reliable and high performance, to save you the trouble of dealing with this crap or hosting it yourself at all?

Put in your layout:

    <%= stylesheet_link_tag "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/cupertino/jquery-ui.css" %>

Replace ‘cupertino’ with whatever theme you want. Some legacy versions of themes also available, replace “1.8.16″ with “1.7.2″ for instance.

Or, do an import in your application.css instead:

    @import url(http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/cupertino/jquery-ui.css)

It’ll still be an extra browser request, but it seems pleasant to keep all your CSS stuff, internal and external,  in your application.css, rather than splitting some of it out to the layout and then getting confused later.  CSS @import seems to be supported in all non-ancient browsers including IE6.

### Fourth way, host it but skip the asset pipeline

Just cause you’re using the Rails 3.1 asset pipeline doesn’t mean you have to use it for all your assets. The Rails asset pipeline guide even says:

> This is not to say that assets can (or should) no longer be placed in public; they still can be and will be served as static files by the application or web server. You would only use app/assets if you wish your files to undergo some pre-processing before they are served.

While we don’t really want any pre-processing of the source itself, if we just put the assets into public we do give up a couple things. We’d give up combining the CSS itself into assets.css to save a browser request (no big deal to save a headache in this special case, sez me. I ain’t running netflix here.) And we’d give up the cache-busting fingerprinting (again, seems tolerable to me — you aren’t going to be changing your jquery-ui theme very often, when you do, just make the changed theme a new theme in a new directory location in ./public, seems okay to me for most cases).

Now, the rails asset pipeline guide says you can do this, but it ends up being a pain, because when you have the asset pipeline turned on, you don’t have any helper methods anymore to generate URLs to assets in ./public, all the helper methods assume they’ll want an asset-pipeline-controlled asset. (Unless there’s a helper method I can’t find somewhere? Come on Rails, if you’re going to tell us it’s an option, can’t you support us doing it?)

You could I suppose just write hard-coded literal URLs — but that breaks if you are deploying an app at a sub-dir of your webserver, as Rails supports, and as I like to be able to do sometimes.

Okay, so create your own helper method, here you go, stick it in a helper somewhere:

    # Much like usual rails route helpers, 
    # whether you realized it or not, you can pass 
    # option :only_path => false to get a
    # full URL instead of a 
    # relative path. 
     def public_static_path(path, options = nil)
       root_path(options) + path
     end
Now stick the jquery-UI theme at ./public/jquery-ui/cupertino, and in your layout:

    <%= stylesheet_link_tag public_static_path("jquery-ui/cupertino/jquery-ui-1.8.16") %>

It’s not in the asset pipeline, but no problem.

What if you want to stick it in application.css with an “@import” instead? Make it into application.css.erb so we can use ERB to call out to a helper to generate the URL… Oops, again we run into the problem of having no way to generate the URL to the asset in public.  A helper method you add to your usual app helpers isn’t available in an erb asset. Yeah, there is a way to monkey-patch helpers into the asset context too, but I went down that path and it started getting more complicated there were a couple other tricks, so I just gave up. Oh well.

### The end

The end. Any improvements, feedback, alternate methods, welcome. I wasn’t actually finding any of these suggestions on google myself (maybe i’m just a bad googler), so hopefully having em here now will make it easier for others trying to figure out what’s going on. Symbolic links, geez, you don’t have to do that.

#### harvinius says:
April 2, 2012 at 1:10 am
I’m running Rails 3.2.1 and managed to get everything running by doing to following.

1. I downloaded a custom version of jquery ui and copied the .js file to /app/assets/javascripts/vendor/jquery-ui-1.8.18.custom.min.js
2. I copied the stylesheet into /app/assets/stylesheets/vendor/jquery-ui-1.8.18.custom.css
3. I copied the images into /app/assets/vendor/images/…

So as long as all the asset paths mirror each other (in my case everything is under a ‘vendor’ folder) it just works without messing around with application configuration.

Possibly there have been some changes since this article was written which makes this a bit easier now.

Scott Harvey

## `link_to_function` method depricated in Rails 3.2

`link_to_function` helper has been deprecated again in 3.2.4 .

The method itself is quite simply and good in some usecases when you need to call specific javascript function etc. You can easily add your own helper to achieve the same functionality. Following code copied from Jeremy in

https://gist.github.com/rails/rails/pull/5922#issuecomment-5770442

    # /app/helpers/link_to_function_helper.rb
    module LinkToFunctionHelper
      def link_to_function(name, *args, &block)
         html_options = args.extract_options!.symbolize_keys
    
         function = block_given? ? update_page(&block) : args[0] || ''
         onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
         href = html_options[:href] || '#'
    
         content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
      end
    end

Could you be a bit more specific about the reason why `button_to_function` should be deprecated?

To be a bit more specific, I have following code:

view:

    <%= form_tag('/products', method: 'post', remote: true) do %>
        <div id="product_errors" style="display:none"></div>
        <%= button_to_function 'Add field', "$.addField($('#mongoField').val());"%>
        <%= text_field_tag 'mongoField', 'pcode' %>
        <div id="mongoFields"></div>
        <br/>
        <%= submit_tag 'Add/update' %>
    <% end %>
custom.js:

    $.addField = function(field) {
        $('#mongoFields').append('\
            <br />\
            <label for="product_' + field + '">' + field + '</label>\
            <input id="product_' + field + '" name="product[' + field + ']" type="text" value="" />'
        );
    };

The `button_to_function` call adds a new input field to the form representing customized database record bound to be saved into MongoDB.

You can archive the same behavior with:

    = form_tag('/products', method: 'post', remote: true) do 
        #product_errors(style="display:none")
        = button_tag 'Add field',  :class => 'add_field'
        = text_field_tag 'mongoField', 'pcode'
        #mongoFields
        %br
        = submit_tag 'Add/update'

    $ ->
      $(".add_field").click (e) ->
        $.addField $("#mongoField").val()
        e.preventDefault()

I strongly recommend that you learn about unobtrusive javascript as I mentioned before in this pull request.