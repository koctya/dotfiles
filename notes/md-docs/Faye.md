# Faye
## Rails pub/sub with faye
In a Rails app I've used Faye (Rack adapter) for push notifications (for chat).

I want to use Faye for another use case (more push notifications) but I can't seem to figure it out.

In my app a model can be created from a background job so I want to refresh one of my views (say the index action) when the model gets created.

Like so:

app/models/post.rb

    class Post
        include Mongoid::Document
    
        after_create :notify_subscribers
    
        private
        def notify_subscribers
            Faye::Client.publish("/posts")
        end
    end
app/views/posts/index.html.erb

    <%= subscribe_to(posts_url) do %>
       uhh what do I do here? ajax call to refresh the whole page??
    <% end %>

So is publishing the notification directly from an after_create callback a good idea and when I get a message from the Faye server how to I go about implementing the "update"? Do I just do an AJAX call to reload the data from the server? That seems like it would be slow.

Further I want to use something similar for updates to the model (say a user added some comments or the author changed the content) so thrashing the DB all the time doesn't seem like a good plan...

####Answer
First of all, yes, publishing the notification with after_create is fine. What you should do in your notify_subscribers method is to publish all relevant information about the new post that you want to use in the client so that you don't have to make another unnecessary AJAX request when the notification is received.

So, for instance, if the title and content of the post are relevant for the user to see immediately after it gets created, you would do something like:

    def notify_subscribers
      client = Faye::Client.new('http://localhost:3000/faye')
      client.publish("/posts/new", {
        'title' => self.title,
        'content' => self.content
      })
    end
...and then, in the view, you would probably use jQuery to use the data about the new post which you receive from the server. Rails code won't help you here. E.g. you would do this (assuming you're using jQuery and have included faye.js in your header):

    <script type="text/javascript">
    $(function() {
      var client = new Faye.Client('http://localhost:3000/faye');
      client.subscribe("/posts/new", function(data) {
        /* do whatever you need with data */
      });
    });
    </script>
Finally, if somehow the information you want to transfer is too complex to transfer as part of the notification, or you already have existing AJAX processes for updating your view, you could just publish the post's ID and trigger an AJAX call with jQuery in the subscribe callback function. I'd recommend this only if necessary though.

> How do you do it my Faye refuses to work form config.ru And I get 'RuntimeError: eventmachine not initialized: evma_connect_to_server' every time i try to create Post object. What's wrong? – prikha Mar 11 at 9:51

> @prikha have you managed to solve that? I am having the very same problem. – Eduardo May 3 at 22:08

> @Eduardo Yepp! Everything goes when you start using proper stack. Unicorn + Thin. And using faye loads EM. – prikha May 17 at 9:26

### Checking if the Faye server exists before running it for my Rails app

Autorun the Faye server when I start the Rails server

I am now running the Faye server whenever I start Rails. However, this means it is trying to run the Faye server when I run the Rails server, the Rails console, or anything else Rails related.

Is there a way to check if the Faye server is already running? And if it is, not attempt to run a new one? Or maybe this isn't the best approach, I welcome all ideas and tips.

#### Answer
You can use the [DaemonController](https://github.com/FooBarWidget/daemon_controller) library. It will enable you to auto-start services with your Rails app, starting them if they aren't already started.

###Faye Server as daemon or automatically started
I want to use Faye on production server on my VPS. how can I start faye server automatically or as a daemon process.

I use faye as my message server currently. Perhaps you would want to make faye as a daemon. I use this for my faye app.

http://rubygems.org/gems/daemons

just

`gem install daemons`
and edit ur own rake file or a plain ruby to run daemon up. that's all

there are lots of daemon tools for ruby.

You can also combine faye with sinatra or thin, but it's a little bit hassle when you can use daemons and fire it up in 3 mins. :)

### How do I list active subscribers using Faye?
I'm using Faye for dispatching messages and it works well. But I want to retrieve the active connections for a given channel, and things behave a bit differently: See "list active subscribers on a channel".

I want to show the list of current users chatting in a room. I tried to do this by intercepting the /meta/subscribe channel via extensions but I'm not quite sure how to send data like the username to the server.

An intercepted message to /meta/subscribe looks like this:

    {"channel"=>"/meta/subscribe", "clientId"=>"50k233b4smw8z7ux3npas1lva", "subscription"=>"/comments/new", "id"=>"2"}

It'd be nice to send `"username" => "foo"`.

Monitoring is interesting too, but again, it looks like I can't send any specific data on-subscribe.

Does anyone have experience with these kind of issues?

> You can attach data using a client-side extension:

    client.addExtension({
      outgoing: function(message, callback) {
        if (message.channel === '/meta/subscribe') {
          message.ext = message.ext || {};
          message.ext.username = 'username';
        }
        callback(message);
      }
    });
> This data will then be visible to your server-side extension. However, before you implement that, read this thread: https://groups.google.com/group/faye-users/msg/53ff678bcb726fc5

> Have you considered creating a channel for periodically publishing which channel a user is currently subscribed to? You can think of it like a heartbeat/ping with additional status information such as which user and channel they may be subscribed to.
