# jQuery

# jQuery UI
## [Easy Tooltips With jQuery UI](http://blog.ricodigo.com/blog/2012/02/17/easy-tooltips-with-jquery-ui/)

There are tons of fancy tooltips plugins available. However, thanks to the position method of jQuery UI, you may not need any of these (if you’re already using jQuery UI) as I’ve found out while adding tooltips to the next Shapado.

One of the ways to do this it to just add a div that will contain the text of your tooltip, in this case we’ll just give it the class ‘tooltip’.

    <p>Show me that cool <a class='special'>tooltip</a>.</p>
    <div class='tooltip'>
      <div class=arrow>▲</div>
      <div class=text>This is so cool</div>
    </div>
And then add some JS:

    $(document).ready(function(){
      $('.special').hover(function(){
      $(this).next('.tooltip').show();
      $(this).next('.tooltip').
        position({at: 'bottom center', of: $(this), my: 'top'})
    });

What we’re doing here is that when the user hovers over the link, we show the tooltip div and position it at the bottom of the link using the jQuery UI position method.

    $('.special').mouseleave(function(){
      $('.tooltip').hide();
    });

And then we just hide it when the mouse leaves the link. You could also set a timer to close it or add a button inside the tooltip to close it manually, this is useful if the tooltip contains some medias such as a youtube video or links.

Now we just add a bit of styling and that’s it!

    .tooltip{
      text-align: center;
      color: black;
      display: none;
      position: absolute;
    }
    .tooltip .text{
      background-color: black;
      color:white;
      margin-top: -15px;
    }
    .tooltip .arrow {margin-bottom: 8px;margin-top: -5px;}

You can obviously add more or less styling to your liking.
Now show me that cool TOOLTIP!
You can read more about jQuery UI position [here](http://jqueryui.com/demos/position/)

## Simple Bookmarklet to Debug Your Rails Assets and Sprockets Apps

Rails assets pipeline is a really conveniant way to manage your assets. However, the problem is that it doesn’t make it easy to debug your Javascript as it packs all files together. You can get errors such as “error at line 4225” and that doesn’t help much. The workaround is to pass the debug option to your javascript include tag so that your js files aren’t packed together:

    <%= javascript_include_tag "application", 
        :debug => Rails.env.development? %> 
However, if like me you include many js files in your rails app, your app will take ages to load in your browser so you may not always want to load all your js files one by one in dev mode especially when you’re not trying to debug your js code. So a quick hack is to add a check for a param such as ‘jsdebug’ in your include tag such as:

    <%= javascript_include_tag "application", 
        :debug => Rails.env.development? && params[:jsdebug]  %> 
So now you just need to add ?jsdebug to your location and hit refresh.

In fact, you can get rid of the development check so that you can debug your js even in prod, just make sure to make the param name longer and not easily guessable.

Finally, if you don’t want to type the params manually everytime you want to debug your app’s js, just drag and drop this bookmarlet: [js debug](javascript:(function(a){var params = document.location.search.substr(1).split('&'); params.push('jsdebug'); document.location.search = params.join('&');})(window);).

## An Alternative to Attr_accessible to Keep Updates Safe

If you’ve read the news today on HN, someone has been pushing commits to the rails repo by using a [mass assignment trick](https://github.com/rails/rails/issues/5228). The problem is now fixed although the drama is still ongoing.

There’s been a great proposal by wycatz posted [here](https://gist.github.com/1974187). We do it another way using mongoid_ext’s safe_update method that you can check here, this is how it looks like:

    module MongoidExt
      module Update
        def safe_update(white_list, values)
          white_list.each do |key|
            send("#{key}=", values[key]) if values.has_key?(key)
          end
        end
      end
    end
It’s just simple white-listing but it’s very explicit and straight forward to use. This is what goes into the update method in shapado for example:

     @question.updated_by = current_user
     @question.safe_update(%w[title body language], params[:question])
So only the params specified in safe_update are being saved. If I add a new field to the model, I have to explicitely add it to the safe_update method, otherwise it won’t get saved. It requires a bit of extra work but the good thing is that I know at all time what’s being sent and updated everytime I look at that method and it forces me to maintain it correctly. It’s not incompatible with scaffolding as it could still add the default fields to safe_update on generating the controller methods.

**Update**: As reported in the comments and on Twitter by DHH himself, using slice on update_attributes would have the same effect. So you could just do:

    @question.update_attributes(params[:question].slice(:title, :body, :language))

## [JQuery-UI css and images, and Rails Asset Pipeline](https://bibwild.wordpress.com/2011/12/08/jquery-ui-css-and-images-and-rails-asset-pipeline/)

###For Rails 3.1 (3.1.3 is the latest release as I write this).

If you have JQuery-UI CSS generated by the [theme roller](http://jqueryui.com/themeroller/), say for the ‘cupertino’ theme. One option is exploding the contents a bit, put the `jquery-ui-1.8.16.custom.css` file directly at `./app/assets/stylesheets/jquery-ui-1.8.16.custom.css`, and put the corresponding jquery-ui theme `./images` subdir directly at `./app/assets/stylesheets/images.`  (Or ./vendor/assets or ./lib/assets). Now just include the .css file in your application.css, “ *= require jquery-ui-1.8.16.custom.css “.

If instead you really do want to leave the JQuery-UI theme source in it’s own subdir by itself, say at `./app/assets/stylesheets/jquery-ui/cupertino` (or ./vendor/assets or ./lib/assets), then you’ve got to add this to your config/application.rb, matching the file path you’ve chosen to put it at:

    initializer :after_append_asset_paths, 
                :group => :all, 
                :after => :append_assets_path do
       config.assets.paths.unshift Rails.root.join("app", "assets", "stylesheets", "jquery-ui", "cupertino").to_s
    end

Your JQuery-UI theme images will now work, both in standard development config, standard production, as well as other combinations of asset piepline configuration.  Works well as far as I can tell in Rails 3.1.3, probably will continue working in the future. (can put in ./vendor/assets or ./lib/assets  instead of ./app/assets, same thing).

For more info and a couple other options, read on.

### The problem

The [jquery-rails gem](https://github.com/indirect/jquery-rails), which is added to a new app’s Gemfile by default in rails 3.1, comes with JS for JQuery-UI.  You can include JQuery-UI JS just by adding this to your application.js:

    //= require jquery-ui
Okay, but what about the JQuery-UI theme, which is CSS and some images referenced by that CSS?  The jquery-rails README kind of unhelpfully suggests:

>In order to use the themed parts of jQuery UI, you will also need to supply your own theme CSS. See jqueryui.com for more information.

Okay, but if you do this the most straightforward way, you’ll find out it doesn’t work. I download a theme, say for the theme ‘cupertino’, and I get a zipfile `jquery-ui-1.8.16.custom.zip`.  Inside there, is a ./css directory.

Okay, I take this ./css directory and actually rename it into my app, say at: `./app/assets/stylesheets/jquery-ui`.  (Can put it in ./vendor/assets too, or even ./lib/assets, all will have the same outcome).

So now inside my local `./app/assets/stylesheets/jquery-ui`, I’ve got `./cupertino`, `./cupertino/jquery-ui-1.8.16.custom.css`, and `./cupertino/images`

So I go into my ./app/assets/application.css, and add:

    *= require jquery-ui/cupertino/jquery-ui-1.8.16.custom.css
Start up my app, with some JQuery-UI code activated, and everything works fine in standard ‘development’ mode configuration. But in ‘production’ mode, with pre-compiled assets, none of the JQuery-UI theme images show up. (Which in some cases degrades usably but not as aesthetic, in other cases is a usability problem like lack of a ‘close’ button on a dialog).

What happened? Well, when compiled under sprockets, the contents of jquery-ui-1.8.16.custom.css is actually combined into the application.css file, which lives at the **URL** (for an app mounted at host root URL:( `/assets/application.css`.   But that JQuery-UI CSS contains relative URLs to image assets, of the form `url(images/something.png)`

And relative to `/assets/application.css`, that means `/assets/images/something.png`.  But sprockets actually compiled the images to file path `./public/assets/jquery-ui/cupertino/images/something.png`, where it’ll be at url `/assets/jquery-ui/cupertino/images/something.png`  Not the right place for the CSS.

If I look around on the web for solutions to this, you get a lot of conflicting and confusing answers, perhaps because they were written for different versions of the asset pipeline (inc. some pre-release versions).  I’m not even going to link you to the various reddits, stackoverflows, etc, because it’s just too confusing and depressing. The most popular one seems to involve making symbolic links in your source. Come on really? Symbolic links, that tend to go wrong if you don’t do things perfectly when zipping up your source or copying it to another place or on Windows? I figured there’s got to be a better way.

In fact, I’m going to give you not just one alternate/better way, but four (count them, one, two, three, four) alternate/better ways.  Well, that’s kind of a lie, I’ll give you two better way that actually work with the asset pipeline, and two more that don’t use the pipeline for jquery-ui theme, but you can still use in your app that otherwise uses the pipeline.  For typical cases, any of em could work, but weird cases (say, wanting to have more than one theme available at runtime) each has trade-offs.

### One way that works with the pipeline, take apart the subdir structure

Just take the files out of the jquery-ui generated directory stucture, and  put `jquery-ui-1.8.16.custom.css` directly  at ./app/assets/stylesheets/jquery-ui-1.8.16.custom.css, and put the corresponding jquery-ui theme ./images subdir _directly_ at `./app/assets/stylesheets/images.`

(Or put em in ./vendor/assets or ./lib/assets, will work identically in any of those. Maybe vendor is best, I dunno).

Now in your application.css, just

     *= require jquery-ui-1.8.16.custom.css

Now the relative paths in the CSS will resolve correctly both with and without pre-compiled assets, as well as even with `config.assets.debug = false` in dev.

Great, that’s pretty simple. I have to admit I didn’t think of this until I had spent quite a bit of time figuring out the next way, which will work with whatever subdirectory structure you want. Hey, maybe you really want to keep the subdir structure to keep your jquery-ui theme stuff nicely segregated. Or maybe you just want to learn a bit more about how Rails and [Sprockets](https://github.com/sstephenson/sprockets) work. Then read, on.

Second way that works with the pipeline, whatever subdirs you want

So maybe you really still want to keep your jquery-ui theme all nicely grouped together in a subdir,  `./(app|vendor|lib)/assets/stylesheets/jquery-ui/themename`.  Just cause it’s tidier, or becuase you need multiple themes installed in your source (although that latter gets trickier).

First I thought, okay, well, maybe we can just add `./app/vendor/assets/stylesheets/themename`  to config.assets.paths in application.rb, now we’re telling sprockets to treat that as a ‘base’ dir, and compile the stuff (images in this case) in there directly to ./public/assets without the parent dirs, keeping the relative paths working.

Turns out I was on the right track, but that doesn’t work. Because  it turns out the *order* of paths matters to the Sprockets device that compiles assets. And Rails insists on adding ./(app|lib|vendor)/assets to the paths before anything you add yourself in config.assets.paths .  And Sprockets will then compile your stuff at that path, and when it sees a different subsequent path that also matches those same files, Sprockets is smart enough to know it already compiled that stuff from the previous path, and not compile it again.  So your addition to config.assets.paths of a subdir of one of the paths listed earlier essentially does nothing.

Turns out the place Rails insists on adding it’s own default paths first is in an [`append_assets_path initializer`](https://github.com/rails/rails/blob/v3.1.3/railties/lib/rails/engine.rb#L542).    (Yes, despite the name “`append_`”, it actually prepends em with `Array#unshift`. Maybe it used to append but was changed to prepend to fix some other desired behavior?). Okay, great, the Rails 3.x initializer framework let’s us hook in right after Rails does this, to put what we want first in config.assets.paths instead.

Say we have our jquery-ui theme at `./vendor/assets/stylesheets/jquery-ui/cupertino`.  Add that path to the beginning of config.assets.paths, even before the stuff Rails prepended, by putting this in your config/application.rb:

    initializer :after_append_asset_paths, 
                :group => :all, 
                :after => :append_assets_path do
       config.assets.paths.unshift Rails.root.join("vendor", "assets", "stylesheets", "jquery-ui", "cupertino").to_s
    end
This works, to get the theme css’s relative URLs to images working,  in default (as installed by Rails) development mode asset config. It works in default production mode asset config, with precompiled assets.  It even works in development mode but with `config.assets.debug = false`. Each of these setups winds up with different ways of serving assets and potentially different path relationships between assets, but this works in every combo I tried. (Some of them probably work because config.assets.paths, depending on assets config, is sometimes used to create routing to assets too).

Will this keep working in the future? I dunno, I’m not technically using any internal API or anything, but I doing something not documented or popular, and counting on internal implementation not changing that much, the :append_assets_path initiailizer remaining there and named the same and used in the same way, etc. Guess it depends on how much Rails changes, like usual.

### How the heck did I figure that out

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

Just cause you’re using the Rails 3.1 asset pipeline doesn’t mean you have to use it for all your assets. The [Rails asset pipeline guide](http://guides.rubyonrails.org/asset_pipeline.html) even says:

> This is not to say that assets can (or should) no longer be placed in public; they still can be and will be served as static files by the application or web server. You would only use `app/assets` if you wish your files to undergo some pre-processing before they are served.

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


### Responses to JQuery-UI css and images, and Rails Asset Pipeline

> Carl Hörberg (@carlhoerberg) says:
December 9, 2011 at 3:35 am
Let the pipeline rewrite the urls instead: https://github.com/carlhoerberg/sprockets-urlrewriter

> Jo Liss says:
February 20, 2012 at 11:05 am
Tom Harrison wrote:
        > One other option we considered was to make a copy of a given jQuery file, make a SASS file by renaming to *.css.scss — then search and replace in the SASS file using the image-url helpers.
        
>That search-and-replace pretty much what the Rakefile in jquery-ui-rails does: http://github.com/joliss/jquery-ui-rails The thusly-modified asset files are then distributed in the jquery-ui-rails gem.

> I released it just now — see http://www.solitr.com/blog/2012/02/jquery-ui-rails-gem-for-the-asset-pipeline/ — but so far it seems to be working well.

> Jo Liss says:
February 23, 2012 at 5:03 pm
… this would also be useful for external themes like this one: http://gravityonmars.github.com/Selene/

#### other solution

By now we are at rails 3.2.8, and maybe things have changed since the post was originally written. 

It seems to me that a lot of confusion can be avoided by keeping these library assets out of assets/javascripts and assets/stylesheets dirs, where sprockets et al have some opinions about what should happen.

Say you've downloaded a customized jquery-ui zipfile from the themeroller. Try this:

1. unpack the zip file into an subdir of an assets dir, something like

        vendor/assets/jquery-ui-1.8.23.custom
2. in application.rb add:

        config.assets.paths << Rails.root.join('vendor', 'assets', 'jquery-ui-1.8.23.custom').to_s
3. add manifest files in the usual places:

    vendor/assets/javascripts/jquery-ui.js:

        //= require_tree ../jquery-ui-1.8.23.custom
    vendor/assets/stylesheets/jquery-ui.css:

        *= require_tree ../jquery-ui.1.8.23.custom
4. in config/environments/production.rb, add (referring to manifest filenames):

        config.assets.precompile += %w(jquery-ui.js jquery-ui.css)
5. in views:

        <%= stylesheet_link_tag 'jquery-ui' %>
        <%= javascript_include_tag 'jquery-ui' %>

