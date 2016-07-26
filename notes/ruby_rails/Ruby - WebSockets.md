# Ruby - WebSockets
## [Ruby & WebSockets: TCP for the Browser](http://www.igvita.com/2009/12/22/ruby-websockets-tcp-for-the-browser/)
By [Ilya Grigorik](http://www.igvita.com/) on December 22, 2009

![](images/whtml5.jpg)
WebSockets are one of the most underappreciated innovations in HTML5. Unlike local storage, canvas, web workers, or even video playback, the benefits of the [WebSocket API](http://dev.w3.org/html5/websockets/) are not immediately apparent to the end user. In fact, over the course of the past decade we have invented a dozen technologies to solve the problem of asynchronous and bi-directional communication between the browser and the server: AJAX, [Comet & HTTP Streaming](http://www.igvita.com/2009/10/21/nginx-comet-low-latency-server-push/), BOSH, [ReverseHTTP](http://www.igvita.com/2009/08/18/smart-clients-reversehttp-websockets/), [WebHooks & PubSubHubbub](http://www.igvita.com/2009/06/29/http-pubsub-webhooks-pubsubhubbub/), and Flash sockets amongst many others. Having said that, it does not take much experience with any of the above to realize that each has a weak spot and none solve the fundamental problem: web-browsers of yesterday were not designed for bi-directional communication.

WebSockets in HTML5 change all of that as they were designed from the ground up to be data agnostic (binary or text) with support for full-duplex communication. **WebSockets are TCP for the web-browser**. Unlike BOSH or equivalents, they require only a single connection, which translates into much better resource utilization for both the server and the client. Likewise, WebSockets are proxy and firewall aware, can operate over SSL and leverage the HTTP channel to accomplish all of the above - your existing load balancers, proxies and routers will work just fine.

### WebSockets in the Browser: Chrome, Firefox & Safari
![](images/wwebsocket-browsers.jpg)
The WebSocket API is still a draft, but the developers of our favorite browsers have already implemented much of the functionality. Chrome’s developer build (4.0.249.0) now officially supports the API and has it enabled by default. Webkit nightly builds also support WebSockets, and Firefox has an outstanding patch under review. In other words, while mainstream adoption is still on the horizon, as developers we can start thinking about much improved architectures that WebSockets enable. A minimal example with the help of jQuery:

    <html>
      <head>
        <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js'></script>
        <script>
          $(document).ready(function(){
            function debug(str){ $("#debug").append("<p>"+str+"</p>"); };
    
            ws = new WebSocket("ws://yourservice.com/websocket");
            ws.onmessage = function(evt) { $("#msg").append("<p>"+evt.data+"</p>"); };
            ws.onclose = function() { debug("socket closed"); };
            ws.onopen = function() {
              debug("connected...");
              ws.send("hello server");
            };
          });
        </script>
      </head>
      <body>
        <div id="debug"></div>
        <div id="msg"></div>
      </body>
    </html>

The above example showcases the bi-directional nature of WebSockets: send pushes data to the server, and onmessage callback is invoked anytime the server pushes data to the client. No need for long-polling, HTTP header overhead, or juggling multiple connections. In fact, you could even deploy the WebSocket API today without waiting for the browser adoption by using a Flash socket as an intermediate step: [web-socket-js](http://github.com/gimite/web-socket-js).

###Streaming Data to WebSocket Clients

WebSockets are not the same as raw TCP sockets and for a good reason. While it may seem tempting to be able to open a raw TCP connections from within the browser, the security of the browser would be immediately compromised: any website could then access the network on behalf of the user, within the same security context as the user. For example, a website could open a connection to a remote SMTP server and start delivering spam - a scary thought. Instead, WebSockets extend the HTTP protocol by defining a special handshake in order for the browser to establish a connection. In other words, it is an opt-in protocol which requires a standalone server.

![](images/wwebsocket-chat.png)

Nothing stops you from talking to an SMTP, AMQP, or any other server via the raw protocol, but you will have to introduce a WebSocket server in between to mediate the connection. [Kaazing Gateway](http://www.kaazing.org/confluence/display/KAAZING/What+is+Kaazing+Open+Gateway) already provides adapters for STOMP and Apache ActiveMQ, and you could also implement your own JavaScript wrappers for others. And if a Java based WebSocket server is not for you, Ruby EventMachine also allows us to build a very simple event-driven WebSocket server in just a few lines of code:

    require 'em-websocket'
    
    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      ws.onopen    { ws.send "Hello Client!"}
      ws.onmessage { |msg| ws.send "Pong: #{msg}" }
      ws.onclose   { puts "WebSocket closed" }
    end

[em-websocket](http://www.github.com/igrigorik/em-websocket/tree/master/.git) - Ruby EventMachine WebSocket Server

### Consuming WebSocket Services

Support for WebSockets in Chrome and Safari also means that our mobile devices will soon support bi-directional push, which is both easier on the battery, and much more efficient for bandwidth consumption. However, WebSockets can also be utilized outside of the browser (ex: real-time data firehose), which means that a regular Ruby HTTP client should be able to handle WebSockets as well:

    require 'eventmachine'
    require 'em-http-request'
    
    EventMachine.run {
      http = EventMachine::HttpRequest.new("ws://yourservice.com/websocket").get :timeout => 0
    
      http.errback { puts "oops" }
      http.callback {
        puts "WebSocket connected!"
        http.send("Hello client")
      }
    
      http.stream { |msg|
        puts "Recieved: #{msg}"
        http.send "Pong: #{msg}"
      }
    }

[em-http-request](http://www.github.com/igrigorik/em-http-request/tree/master/.git) - Asynchronous HTTP Client
WebSocket support is still an experimental branch within em-http-request, but the aim is to provide a consistent and fully transparent API: simply specify a WebSocket resource and it will do the rest, just as if you were using a streaming HTTP connection! Best of all, HTTP & OAuth authentication, proxies and existing load balancers will all work and play nicely with this new delivery model.

### WebHooks, PubSubHubbub, WebSockets, ...

Of course, WebSockets are not the panacea to every problem. [WebHooks and PubSubHubbub](http://www.igvita.com/2009/06/29/http-pubsub-webhooks-pubsubhubbub/) are great protocols for intermittent push updates where a long-lived TCP connection may prove to be inefficient. Likewise, if you require non-trivial routing then [AMQP is a powerful tool](http://www.igvita.com/2009/10/08/advanced-messaging-routing-with-amqp/), and there is little reason to reinvent the powerful [presence model built into XMPP](http://www.igvita.com/2009/11/10/consuming-xmpp-pubsub-in-ruby/). Right tool for the right job, but WebSockets are without a doubt a much-needed addition to every developers toolkit.

## Stage left: Enter Goliath
Posted on March 8, 2011 by dj2
Over at PostRank Labs we’ve released the current version of our API server framework to the wild. Allow me to introduce [Goliath](http://goliath.io/). Goliath is built on the back of the work at PostRank, [Thin](http://code.macournoyer.com/thin/), [Sinatra](http://www.sinatrarb.com/), [http-parser.rb](https://github.com/copiousfreetime/http-parser.rb) and various other projects.

We’ve been using a version of Goliath internally for over a year serving a sustained 500 requests/sec and shuttling around gigabytes of data.

How did we get here you’re asking? Our API servers from the beginning have been built on the awesome [EventMachine](http://rubyeventmachine.org/) library. The last several iterations have used a threaded model. A request comes in, a thread is grabbed from the pool, request is processed, thread goes back to the pool. This was cool and worked quite well for us for several years. The problem we ran into, we were getting spaghetti code. A lot of our APIs call other APIs internally. Handling the callbacks, error backs and various other delayed operations was getting difficult to maintain.

Then along wandered [Ruby 1.9](http://ruby-lang.org/) with these cool little things called [Fibers](http://www.ruby-doc.org/core-1.9/classes/Fiber.html). Fibers allow us to build synchronous looking code backed by asynchronous calls. To achieve this we’re using the [EM-Synchrony](http://github.com/igrigorik/em-synchrony) library. Tying this back into Goliath, as each request comes in, a new Fiber is created, the request is processed within that Fiber and, when completed, the Fiber goes away.

Once we had the foundation in place we went a step further and built a few extra little goodies into Goliath including streaming requests and responses. This lets us do some cool things like hook AMQP exchanges up to a Goliath API to pipe content through a streaming response.

Using http-parser.rb allows us to open up the option of alternate Ruby VMs. At the time of writing, Goliath has been tested with MRI, JRuby and Rubinius. MRI is currently the fastest VM for Goliath but there is lots of work going on in the alternate VMs to make them faster.

Ok, ok, enough of the hype, lets see some code already.

Well, first we need to get Goliath installed. In general this is pretty simple, you can use your system Ruby, RVM or some other system and all you need to do is:

    gem install goliath

What we’re going to build here is an HTTP proxy that stores information about each request/response into [MongoDB](http://www.mongodb.org/). (The full code listing can be found in t[his gist](https://gist.github.com/7c2fe52d73fb290690cf).)

Before we dig into the code, a little on how Goliath works. By default, Goliath will execute your API when you run the API file. In order to do this, the API file has to have a snake cased name based on the class name. So, our HttpLog API will live in a file called http_log.rb. When you need to add configuration to your API you’ll do this by creating a config directory in the same directory as your file. You then create a file in the config directory with the same name as your API. In our case, we’ll create a config/http_log.rb file to hold our configuration.

Goliath has been built to be [Rack](http://rack.rubyforge.org/)-aware. This means we can make use of Rack middlewares, as long as they’re async safe or have been wrapped by [async-rack](https://github.com/rkh/async-rack).

We’re going to build some specs along with our API. Create spec/http_log_spec.rb and we can get this party started.

    require ‘rubygems’
    require ‘goliath/test_helper’
    require File.expand_path(File.join(File.dirname(__FILE__), ‘..’, ‘http_log’))
    describe HttpLog do
      include Goliath::TestHelper
    
      let(:err) { Proc.new { |c| fail "HTTP Request failed #{c.response}" } }
    
      it ‘responds to requests’ do
        with_api(HttpLog) do
          get_request({}, err) do |c|
            c.response_header.status.should == 200
          end
        end
      end
    end

With Goliath we’ve provided a simple `goliath/test_helper` file that makes the testing of APIs a little easier. Once you’ve required the library, you just need to include `Goliath::TestHelper` and you can start using the helper methods. These include the `with_api` and `get_request` methods that are being used above. The with_api call will start an instance of our API running on port 9000 and anything done within its block will executing inside an EM reactor. This method will not return until `stop` is executed.

We’re, essentially, creating an integration test suite for our API. Everything except for the API launching will be tested by the test suite. The configuration files will be parsed, all the middlewares will be loaded and executed. Everything that your normal application would do except for the launching.

Calling `get_request` will send a GET to our API. The first parameter is any query parameters to send to the API. In our case, we send nothing. The second is an error handler to add. This is fired if we are unable to communicate with the API. For this example, we’re just using the RSpec `fail` method to fail the spec in the error handler.

The block passed to get_request will be executed and provided the request object when the request is complete. This allows us to look at the response headers and response body. In this case, we’re just verifying that server responds with a 200 code. When you’re using get_request or post_request a default error and callback handler will be installed that calls stop for you.

With that, running the spec should fail. Let’s create a simple API to make it pass. The following code in http_log.rb will give us a passing spec.

    #!/usr/bin/env ruby
    require ‘rubygems’
    require ‘goliath’
    
    class HttpLog < Goliath::API
      def response(env)
        [200, {}, "Hello"]
      end
    end

You can execute the API with `./http_log.rb -sv` which will launch the API on a default port of 9000.

The `-sv` flags tell the API to log to STDOUT (s) and use verbose logging (v). You can run `./http_log.rb -h` to see a list of all the default options provided by Goliath. You can add your own [options](https://github.com/postrank-labs/goliath/blob/master/examples/conf_test.rb) as well if you need special argument handling for your API.

With the API running we can query the API using curl.

    dj2@titania ~ $ curl localhost:9000
    Hello

Running the spec test again our test case should also pass at this point.

To make our lives easier, we’re going to use the Rack::Reloader middleware to handle reloading our Rack middleware on each request.

This is done by adding use `::Rack::Reloader, 0` into our API. Since we only want reloading when we’re doing development we’re going to make the use statement conditional on the Goliath environment. By default Goliath executes in a development environment. We can confirm this by calling Goliath.dev? which will return true if the current environment is development.

    class HttpLog < Goliath::API
      use ::Rack::Reloader, 0 if Goliath.dev?
      def response(env)
        [200, {}, "Hello"]
      end
    end

You’ll notice that we didn’t create another file to place the middleware. With Goliath, the middleware is built into the API class itself. We’ve found this is a lot easier to deal with when you keep everything together in the same file. (You can also add [plugins](https://github.com/postrank-labs/goliath/wiki/Plugins) in the same fashion by using the plugin keyword.)

The next step is to start forwarding to our backend server. To do this, we’ll specify in our configuration file the forwarder URL. Create `config/http_log.rb` and add the following:

    config[‘forwarder’] = ‘http://localhost:8080′

The config hash allows us to store configuration data that will become available through the env parameter to the response method. In this case, we’ve specified we want our forwarder to send requests to http://localhost:8080.

In order to test this, I’m going to create a Goliath API server inside our spec files. I’ll run the server on port 8080 and check for our server response in the response from our API. Add the following to the top of the spec file.

    class Responder < Goliath::API
      def response(env)
        [200, {"Special" => "Header"}, "Hello World"]
      end
    end

And the following spec:

    it ‘forwards to our API server’ do
      with_api(HttpLog) do
        server(Responder, 8080)
        get_request({}, err) do |c|
          c.response_header.status.should == 200
          c.response_header[‘Special’].should == ‘Header’
          c.response.should == ‘Hello from Responder’
        end
      end

This is similar to our previous spec except I’ve added a `server(Responder, 8080)` call to launch an instance of our Responder API on port 8080. Running this test should fail since we aren’t sending or receiving any data to the proxied API.

As a first pass, we’ll send the request and proxy the responses back.

    def response(env)
      req = EM::HttpRequest.new("#{env.forwarder}").get
      [req.response_header.status, req.response_header, req.response]
    end

So, that’s cool. (Make sure you add the `server(Responder, 8080)` to the first example after doing this or it will end up failing.) There is one, non-apparent problem. It turns out the headers get transformed by `EM-HTTP-Request`. When we go to log this stuff we’ll want the non-transformed headers so we need to transform them back into the normal HTTP header format. Let’s start with a couple tests:

    context ‘HTTP header handling’ do
      it ‘transforms back properly’ do
        hl = HttpLog.new
        hl.to_http_header("SPECIAL").should == ‘Special’
        hl.to_http_header("CONTENT_TYPE").should == ‘Content-Type’
      end
    end

Simple enough, we need to fix the casing and change _ into -. Let’s add that to our HttpLog class.

    def to_http_header(k)
      k.downcase.split(‘_’).collect { |e| e.capitalize }.join(‘-’)
    end

That should make our transform tests pass and we can build the change into the response method by changing it to look like:

    def response(env)
      req = EM::HttpRequest.new("#{env.forwarder}").get
      response_headers = {}
      req.response_header.each_pair do |k, v|
        response_headers[to_http_header(k)] = v
      end
    
      [req.response_header.status, response_headers, req.response]
    end

Cool, so now we’re forwarding all requests to the proxied server. There is a bit of missing information that we need, that being the headers, query parameters, request path and different types of requests from just GET.

Lets start with the query parameters. To test this I’m going to augment our `Responder` class to return the request parameters as part of the headers.

    class Responder < Goliath::API
      use Goliath::Rack::Params
      def response(env)
        query_params = env.params.collect { |param| param.join(": ") }
        headers = {"Special" => "Header",
                   "Params" => query_params.join("|")}
        [200, headers, "Hello from Responder"]
      end
    end

We’re using another middleware here, `Goliath::Rack::Params`, which will parse the query and body parameters and put them into the params hash of the environment. Using that we can send the parameters back as a header in the response.

The test for query parameters is pretty simple, pass them in, make sure they come back:

    context ‘query parameters’ do
      it ‘forwards the query parameters’ do
        with_api(HttpLog) do
          server(Responder, 8080)
          get_request({:query => {:first => :foo, :second => :bar, :third => :baz}}, err) do |c|
            c.response_header.status.should == 200
            c.response_header["PARAMS"].should == "first: foo|second: bar|third: baz"
          end
        end
      end
    end

To make this pass, we just need to use `Goliath::Rack::Params` and change the `EM::HttpRequest#get` request to provide the params. This is done by using: `req = EM::HttpRequest.new("#{env.forwarder}").get({:query => env.params})`.

Next up, let’s handle the request path. We’ll start with the spec.

    context ‘request path’ do
      it ‘forwards the request path’ do
        with_api(HttpLog) do
          server(Responder, 8080)
          get_request({:path => ‘/my/request/path’}, err) do |c|
            c.response_header.status.should == 200
            c.response_header[‘PATH’].should == ‘/my/request/path’
          end
        end
      end
    end

Our Responder needs to return the path in the headers. This is done by adding `"Path" => env[Goliath::Request::REQUEST_PATH]` into the headers return hash. Making this spec pass is as simple as using the same `env[Goliath::Request::REQUEST_PATH]` data in our forwarder request.

    req = EM::HttpRequest.new("#{env.forwarder}#{env[Goliath::Request::REQUEST_PATH]}").get(params)

With the request path out of the way, let’s look into the headers. Goliath has built in facilities to do streaming requests. As part of that, we can hook into the `on_headers` method to receive a callback with the headers when they’re available. We can then store them into the environment and return them in a similar fashion to the query parameters.

We’re going to use the same on_headers callback in the Responder class to give us access to the headers. Then, the same as with query params, we’ll return them in a header for the response.

    class Responder < Goliath::API
      use Goliath::Rack::Params
      def on_headers(env, headers)
        env[‘client-headers’] = headers
      end
    
      def response(env)
        query_params = env.params.collect { |param| param.join(": ") }
        query_headers = env[‘client-headers’].collect { |param| param.join(": ") }
    
        headers = {"Special" => "Header",
                   "Params" => query_params.join("|"),
                   "Path" => env[Goliath::Request::REQUEST_PATH],
                   "Headers" => query_headers.join("|")}
        [200, headers, "Hello from Responder"]
      end
    end

With a spec test similar to the query example as well.

    context ‘headers’ do
      it ‘forwards the headers’ do
        with_api(HttpLog) do
          server(Responder, 8080)
          get_request({:head => {:first => :foo, :second => :bar}}, err) do |c|
            c.response_header.status.should == 200
            c.response_header["HEADERS"].should =~ /First: foo\|Second: bar/
          end
        end
      end
    end

Let’s make the tests pass:

    def on_headers(env, headers)
      env.logger.info ‘proxying new request: ‘ + headers.inspect
      env[‘client-headers’] = headers
    end

You’ll notice I added a call to `env.logger.info`. Goliath comes with built in logging capabilities. The logger is based on Log4r and is accessed through the environment. The Goliath environment is a subclass of Hash and can be accessed as such to store and retrieve information.

Once we’ve got the headers stored, adding them to our request is a simple process.

    params = {:head => env[‘client-headers’], :query => env.params}
    req = EM::HttpRequest.new("#{env.forwarder}#{env[Goliath::Request::REQUEST_PATH]}").get(params)

One step left and our proxy is complete. Let’s send the right request method through to the proxied server (we’re just going to do GET and POST in this example). First step, add `"Method" => env[Goliath::Request::REQUEST_METHOD]` to the headers returned from our Responder API.

We can then add the specs:

    context ‘request method’ do
      it ‘forwards GET requests’ do
        with_api(HttpLog) do
          server(Responder, 8080)
          get_request({}, err) do |c|
            c.response_header.status.should == 200
            c.response_header["METHOD"].should == "GET"
          end
        end
      end
    
      it ‘forwards POST requests’ do
        with_api(HttpLog) do
          server(Responder, 8080)
    
          post_request({}, err) do |c|
            c.response_header.status.should == 200
            c.response_header["METHOD"].should == "POST"
          end
        end
      end
    end

To make this pass we’ll use the `Goliath::Request::REQUEST_METHOD` to determine the right type of request to make. You’ll notice I’m putting the response into a resp variable, so the references to req in the rest of the method need to be update as well.

    req = EM::HttpRequest.new("#{forwarder}#{env[Goliath::Request::REQUEST_PATH]}")
    resp = case(env[Goliath::Request::REQUEST_METHOD])
      when ‘GET’  then req.get(params)
      when ‘POST’ then req.post(params.merge(:body => env[Goliath::Request::RACK_INPUT].read))
      else p "UNKNOWN METHOD #{env[Goliath::Request::REQUEST_METHOD]}"
    end

The only significant change from the previous version, in the POST request, we need to send the body data through to the forwarded server. The body is stored in a `StringIO` object which we can read. The object is stored in the environment under the `Goliath::Request::RACK_INPUT` key.

With that done, we should now have a functioning HTTP proxy.

Let’s take a look at how we can hook this up to *MongoDB* to give us the Log part of our the API name.

In order to talk to MongoDB we’re going to use the em-mongo gem. Since we’re working in an asynchronous environment we may have several requests being processed at the same time, so we’re going to wrap our MongoDB connection into a connection pool. There is connection pool logic built into em-synchrony for us to utilize.

I’m also, for the sake of this tutorial, going to say we don’t want to create a connection to a real Mongo instance when we’re running our spec tests. So, I’m going to restrict the connection creation to only happen in development mode.

Make sense? Ok, add the following to your `config/http_log.rb` file.

    environment(:development) do
      config[‘mongo’] = EventMachine::Synchrony::ConnectionPool.new(size: 20) do
        conn = EM::Mongo::Connection.new(‘localhost’, 27017, 1, {:reconnect_in => 1})
        conn.db(‘http_log’).collection(‘aggregators’)
      end
    end

The environment:)development) will cause this code block to only execute if we’re in development mode. We could have also passed :test or :production depending on which mode we want. Along with a single option, you can also provide an array. So, we could have said environment([:test, :development]) to execute in both test and development mode but not in production mode.

I’m going to leave it as an exercise to you, my reader, to figure out the synchrony and mongo code we’re using in the connection. Let’s just leave it at, we will now have access to a MongoDB collection object in config['mongo'] which we can use in our application.

Just before we return the status, headers and body we’re going to record the request into Mongo. We’ll do that by adding:

    record(process_time, resp, env[‘client-headers’], response_headers)

The implementation of record uses the various environment variables we’ve seen above to do it’s work:

    def record(resp, client_headers, response_headers)
      e = env
      EM.next_tick do
        doc = {
          request: {
            http_method: e[Goliath::Request::REQUEST_METHOD],
            path: e[Goliath::Request::REQUEST_PATH],
            headers: client_headers,
            params: e.params
          },
          response: {
            status: resp.response_header.status,
            length: resp.response.length,
            headers: response_headers,
            body: resp.response
          },
          date: Time.now.to_i
        }
        if e[Goliath::Request::RACK_INPUT]
          doc[:request][:body] = e[Goliath::Request::RACK_INPUT].read
        end
    
        e.mongo.insert(doc)
      end
    end

There are a couple of things to note, first, I’m doing this work in an `EM.next_tick` block so that I don’t block the response from returning to the client. Because I’m doing this in the next tick I’m going to lose access to the env so I tuck it away into a e variable which gets bound up with the next_tick block.

Finally, the last thing we do is call `e.mongo.insert(doc)` which will access the `config['mongo']` object we created earlier and call the insert method.

With that code added, all of our tests fail. We’re going to need to create a mongo key in the environment that the tests can use.

To do that, I’ve created a mock_mongo method:

    def mock_mongo
      @api_server.config[‘mongo’] = mock(‘mongo’).as_null_object
    end

Which I call inside the `with_api(HttpLog)` block. I’ll leave it as an exercise to the reader to create some specs around the record method.

The default API server created inside with_api will be made available to the user through the `@api_server` variable.

With that, you should have a working proxy logger API. If you run webserver on port 8080 and execute the our http logger you can then make requests to port 9000 and see the results logged into mongo. Looking in mongo you should see something similar to:

    connecting to: test
    > use http_log
    switched to db http_log
    > db.aggregators.find();
    { "_id" : ObjectId("4d6efbbad3547d28f3000001"),
      "request" : {
                    "http_method" : "GET",
                    "path" : "/",
                    "headers" : {
                                  "User-Agent" : "curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3",
                                  "Host" : "localhost:9000",
                                  "Accept" : "*/*",
                                  "Version" : "1.1" },
                    "params" : { "echo" : "test" },
                    "body" : "" },
       "response" : {
                    "status" : 200,
                    "length" : 19,
                    "headers" : {
                                  "Content-Type" : "application/json; charset=utf-8",
                                  "Server" : "PostRank Goliath API Server",
                                  "Vary" : "Accept",
                                  "Content-Length" : "19",
                                  "Date" : "Thu, 03 Mar 2011 02:23:54 GMT" },
                    "body" : "{\"response\":\"test\"}" },
       "process_time" : 0.007593870162963867,
       "date" : 1299119034 }

With that, have fun playing with Goliath. We’re hoping people find some interesting uses for the framework.

- [Goliath Docs](http://postrank-labs.github.com/goliath/doc/index.html)
