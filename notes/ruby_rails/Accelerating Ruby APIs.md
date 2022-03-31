# [Accelerating Ruby APIs](http://jgwmaxwell.com/accelerating-ruby-apis/)
DECEMBER 26, 2011 AT 12:44 AM
##Collecting Data through an API

I’ve been working on improving an API that collects stats for an application I run. Initially we were collecting data through Rails, as the rest of the application runs on rails, but I started thinking that this was surely overkill – after all this is simply stats data – what is needed is realtime, highly concurrent collection – which the advanced features of rails are not particularly suited to.

Let’s face it – a packet describing a particular stat is unlikely to be wrongly formed, and the business consequences of saving a malformed packet are low in the extreme, and a background process can quite happily walk through the database removing invalid packages when the service is quiet – allowing eventual validity to occur.

So, I started to re-factor, and more importantly re-think. A stat packet, collected either by a HTTP request – such as for web analytics, or through HTTP POSTing from an application, is essentially a fire and forget piece of information. This led me to thinking:

- Most stats will be aggragated at a later date using MapReduce or Hadoop, and are unlikely to be individually examined.
- The business importance of a single item of statistic data is low, compared to a lineitem in a shopping cart or a payment or email.
- Something that is unlikely to be individually recalled to view doesn’t really justify the overhead of constructing a full model/validation cycle around it when saving.

So, I needed to re-engineer my application to take advantage of a more low-level approach to handling incoming stats. Ideally, I would be able to mount this as a Rack application within my current Rails stack as a straight swap for my current solution, but not being able to do this wouldn’t be a great impediment otherwise.

I’m using MongoDB for collecting this statistic information, and the excellent Mongoid ODM – which I highly recommend, even the slightest things make it a pleasure to work with – such as how it speeds up using the Rails generators, and its performance has come on leaps and bounds recently. All of the following tests are using the latest version of Thin (1.3.1), to help keep some fairness in this.

Benchmarking my current solution, running on localhost (Ubuntu 10.04LTS Server, 8gb Ram, Intel Core i5, Ruby 1.9.2p290 over RVM), averaging 5 runs over 10k gives:

`ab -n 100000 -c 250 http://localhost:3000/stats` – **Rails with Mongoid**


    Concurrency Level:      250
    Time taken for tests:   251.633 seconds
    Complete requests:      100000
    Failed requests:        0
    Requests per second:    397.40 [#/sec]
    95% Request completed within:   3318ms

Those are the key indicators I am interested in, whether the infrastructure is dropping any requests, how quickly 95% of the requests are completed within, and how many requests/sec the unit is shifting in total. Obviously, we can be moving a lot of requests/sec, but if a client is having to wait 3.3 seconds, that is too long – and remember, 5% of 10k is 500 requests – thats a lot of dissatisfied customers.

###Improving the Status Quo

Ok, so the first thing to do is to get rid of Rails. Not permanently – I love it’s power and versatility, but the full Rails stack is simply too massive to operate as a collection point like this. Sinatra is the next logical choice to go to, and known to be a fast and dynamic way of handling web requests. Rewriting the endpoint into Sinatra is simple as we are just saving numerous bits of request data into the database, and returning a 200 code at the end of it. Running exactly the same functional code in Sinatra (even using the same model as Rails…) gives us:

`ab -n 100000 -c 250 http://localhost:4567/stats` – **Sinatra with Mongoid**


    Concurrency Level:      250
    Time taken for tests:   441.888 seconds
    Complete requests:      100000
    Failed requests:        1183
    (Connect: 0, Receive: 0, Length: 1183, Exceptions: 0)
    Requests per second:    226.30 [#/sec]
    95% Request completed within:   1348ms

Well, this wasn’t expected – although it does show just how able the newest version of Rails is (3.2.rc1) to be able to smack Sinatra around like that. Not only did Sinatra fail more than 1% of requests (totally unacceptable), it also only handled them at around half the pace of Rails. Interestingly, the 95%ile was faster by a long way, but that is a solitary bright point here. Possibly the issue here though is that Mongoid isn’t playing nicely with Sinatra. Since we don’t need many of the features of Mongoid, we can bypass most of its stack by interacting with the Mongo::Collection object directly. Essentially this means calling


    Stat.collection.insert({:ip_address => request.ip, :path => request.path, etc})

rather than

    Stat.create(...)

We won’t get any of the higher level features, but hopefully it’ll make things faster!

`ab -n 100000 -c 250 http://localhost:4567/stats` – **Sinatra with Mongoid::Collection inteface**

    Concurrency Level:      250
    Time taken for tests:   353.458 seconds
    Complete requests:      100000
    Failed requests:        3255
    (Connect: 0, Receive: 0, Length: 3255, Exceptions: 0)
    Requests per second:    282.92 [#/sec]
    95% Request completed within:   1265ms

Ok, so we’ve found some more speed by doing that, around 28%, although at the cost of our failure rate going up, which isn’t really acceptable. Looking through the logs, the problem is Mongo::ConnectionFailures – which suggests that we’re having problems with the number of connections that we can open up to MongoDB. Rather than fiddling around with configuring Mongoid itself, we’re going to drop down and use the Ruby driver directly – this will also allow us to configure a connection pool that we can use to give us more connections to the DB. The basic syntax for doing this in ruby is:


    CONN = Mongo::Connection.new("localhost", 27017, :pool_size => 20, :timeout => 5).db("raw_mongo").collection("stats")
    # then call CONN.insert({yourhash})

`ab -n 100000 -c 250 http://localhost:4567/stats` – **Sinatra with pure Mongo**


    Concurrency Level:      250
    Time taken for tests:   173.445 seconds
    Complete requests:      100000
    Failed requests:        0
    Requests per second:    576.55 [#/sec]
    95% Request completed within:   477ms

Wow! Over a 100% improvement in throughput, and the 95% percentile slashed by 0.8seconds, and no failed requests – this is far more impressive stuff, and the kind of improvement that we were really looking for. It does ask the question – what could Rails do, if we refactored to use this method instead of Mongoid? Let’s find out…

`ab -n 100000 -c 250 http://localhost:3000/stats` – **Rails with pure Mongo**


    Concurrency Level:      250
    Time taken for tests:   188.314 seconds
    Complete requests:      100000
    Failed requests:        0
    Requests per second:    531.03 [#/sec]
    95% Request completed within:   3238ms

I’ve got to say that I’m hugely impressed with this one – for Rails to be able to get close to Sinatra when your compare the relative complexity of the applications is amazing. However, we can make this go a LOT faster yet. The problem here is that all the requests coming in are having to wait for the IO interaction with the database. Unfortunately in Ruby, this is a blocking call – it prevents other things happening while we are waiting. So, we need to write some asynchronous code – accepting one request, and firing it off to the database, and then dealing with the next one while its waiting for the response from the last one. Fortunately there are some tools to help us here.

## Enter Synchrony

There are two projects in Sinatra which make it asynchronous, and we’re going to go with one of them, mainly as its a little easier to use, and in my testing seems a little more performant. So, we’re going to re-rig our Sinatra application to use Sinatra::Synchrony. Essentially, this is just a case of requiring the Gem, and then “register Sinatra::Synchrony” inside your app and we are ready to go. Surely those two tiny changes can’t make that much difference though?

`ab -n 100000 -c 250 http://localhost:4567/stats` – **Sinatra Synchrony – pure Mongo**

    Concurrency Level:      250
    Time taken for tests:   59.070 seconds
    Complete requests:      100000
    Failed requests:        0
    Requests per second:    1692.90 [#/sec]
    95% Request completed within:   90ms

I think we can all take a moment here to admire those numbers – it added more than 1100 requests/sec to our speed, or nearly another 200%! And more importantly, it slashed the 95% time to only 90msec – which is more than acceptable. This is really pretty awesome, firing a 100k writes in under a minute, from a single Thin server, with a concurrency of 250, without a single mistake. This is 4x the throughput I started with, without changing any hardware at all – and a prime example of why taking a long hard look at your code is always essential.

Potentially there are some ways that we might be able to even make this a smidge faster. Ruby has another couple of dedicated asynchronous frameworks, rather than Sinatra Synchrony – which is a retrofitted job onto the already excellent Sinatra DSL. These contenders are Goliath and Cramp. Writing code for these requires a different way of thinking about the request, and coding in these languages is a little beyond the scope of this article, but I’ll write a tutorial soon. Let’s put them to the test.

## Goliath

`ab -n 100000 -c 250 http://localhost:9000/stats` – **Goliath – pure Mongo**

    Concurrency Level:      250
    Time taken for tests:   51.952 seconds
    Complete requests:      100000
    Failed requests:        0
    Requests per second:    1924.86 [#/sec]
    95% Request completed within:   74ms

And faster again – another 230 req/sec, even faster response times, and another 7 seconds shaved off the time to write 100k entries. We are nearly holding a solid 2k writes a second here, and the most impressive thing about Goliath is that it is rock solid – it can hold this for hours and days without leaking memory, and without batting an eyelid. People who think Ruby can’t scale really need to actually research what they are saying – on single free dyno from Heroku, you could potentially handle 130million writes/day – if you had somewhere to put all that data!

## Cramp

I really hope that you are prepared to be amazed…

`ab -n 100000 -c 250 http://localhost:3000/stats` – **Cramp – pure Mongo**

    Concurrency Level:      250
    Time taken for tests:   28.441 seconds
    Complete requests:      100000
    Failed requests:        0
    Requests per second:    3516.08 [#/sec]
    95% Request completed within:   53ms

I have to say that I was a little awestruck by this – after all, this is still just a single instance of Thin, and it is still having to write exactly the same record to MongoDB on every single request. Cramp has absolutely blown the competition out of the park with this score, less than 30seconds to write 100k records, all of them dynamically created from the request object and headers, and all of them finished inside 84ms, with 95% inside 53ms. This is the kind of performance that you can build infrastructure on top of, and is an incredible 1000% of the performance I had from my application when I started this process, without any additional hardware.

In fact, whilst the other scores are all the average of 5 runs, the Cramp score is the average of 10 runs, just to make sure that it isn’t a fluke. I’ve run cramp reliably up to 800-or-so concurrent connections using AB, although performance plateaus at the level seen here with 250.

## Conclusion

It is possible to hammer Ruby web services far beyond the level that we normally see when using the more comment frameworks. If you’re looking for a way to scale a little more, or to improve performance that bit beyond where you are at the moment, then why not look at something like Goliath or Cramp to give you the edge.

If anyone is interested, I clocked the same benchmark using node.js and the node native mongodb driver, and only scored #3100 req/sec, which means that Ruby is competing head to head with Node, in a territory that I for one would have assumed that Node would hammer Ruby in.

**UPDATE** – Cramp is also extremely memory efficient – running an “`ab -n 10000000 -c 250`” (yes, 10 million), it used only `21.9mb` of RAM throughout the whole operation which never wavered, held a rock solid #3235 requests/second, and the 99%ile of response time was a mean 47ms.

This had lead me to believe that investigating using Cramp with Rainbows! (an alternative to Thin, based on Unicorn, which allows forking and thus multiple workers) is an exciting proposition. For example, Heroku allows 512mb RAM per Dyno, potentially allowing Rainbows! to safely fork 10-20 workers, allowing an extraordinary concurrency in one single application. This probably wouldn’t massively increase overall throughput, but in a different kind of application, such as a dashboard monitoring events with SSE, you could conceivably hook 10k users up to a single dyno…

**Tags**: API Cramp Goliath Heroku MongoDB Mongoid ODM Rails Scalability Sinatra Thin

**Author**: [JGW Maxwell](http://jgwmaxwell.com/author/jgwmaxwell/)
I'm a freelance web programmer who founded a SaaS startup working in the e-Commerce sector that is about to enter public Beta. I'm fluent in Ruby, PHP, Go and Javascript with a passing interest in Java and Erlang, and happiest when working on large, complex challenges.