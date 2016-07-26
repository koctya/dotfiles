#Benchmarking Ruby on Rails applications – tools for load / performance testing.

JUN 21, 2012 BY [RADOSŁAW JĘDRYSZCZAK](http://www.businesstechnologyarticles.eu/author/radoslawjedryszczak)

In the previous blog article I focused on [designing performance test suites for Ruby on Rails applications](http://www.businesstechnologyarticles.eu/designing-load-performance-test-suites-for-ruby-on-rails-applications-part-one). I made an attempt to capture the differences between performance, load and stress testing. I also discussed some of the issues which frequently need to be addressed during the testing process. I would like to devote this post to **benchmarks and tools** – the topic which deserves a more in-depth treatment.

## A variety of available solutions
As regards performance and benchmarking tools, [a large number of solutions](http://www.opensourcetesting.org/performance.php) available makes the choice hard indeed. **The value of the data collected during performance testing depends, among other things, on the quality of the tool set used for testing**. There is no straightforward answer as regards the selection of testing tools if only for the fact that **each tool comes with specific characteristics which make it more / less suitable for specific scenarios**.

There are benchmarks which measure your application performance and which can be launched by inputting just one command in the console. They usually hit your website with a series / number of requests. Thus the benchmark resembles a DOS attack rather than a performance test. Since that is rarely the purpose of performance testing, I am inclined to use **more sophisticated solutions which allow you to write “user stories” which reflect the business flow of a given web application**. It all boils down to your priorities – what is more important:

- to have confidence that you Ruby on Rails application can sustain a given load and properly perform the tasks it was specifically built for (i.e., the tasks reflecting the business logic) OR
- to find out how your Ruby on Rails application scores against some standard industry benchmarks (e.g. what is your application throughput while serving the homepage)?

On the whole, I attach more importance to the former. Still it is sometimes the case that one needs to tune up specific pages which apparently are a bottleneck in the application. Alternatively, the SLA / performance requirements are tied to some standard industry benchmark tools and thus one needs to monitor the divergence from such an agreed benchmark. Last but not least, a project stakeholder may just expect you to deliver the data gathered by means of a particular tool. Knowing the tools available well provides you with more options with which to address the problem.

Various performance / load benchmarks offer different sets of features and exhibit specific strengths and weaknesses. It is desirable to simulate the user traffic in as realistic manner as possible. While selecting the solutions for comparison, **I gave preference to the benchmarks that are popular, easy to use, reliable or innovative in their approach to user traffic simulation**. The following solutions found their way into the list:

- Apache Bench,
- JMeter,
- tsung,
- httperf,
- httpload,
- Trample

I also added a follow-up section describing performance monitoring tools for Ruby on Rails applications, like New Relic.

## Apache Bench
![](images/apache-rack.png)
I think the reason behind the popularity of Apache Bench is the fact that it is packaged with a very popular server:  the Apache web server. I cannot see many other reasons why Apache Bench has been so widely adopted; the solution does not offer a way to simulate a collection of user sessions performing various actions throughout the system. All the requests produced by Apache Bench are identical. It is not possible to write down a user story, for example: “A user visits home page, clicks on a featured product, adds it to the cart and proceeds to the checkout”. This is a major limitation of AB, but at least benchmarking Ruby on Rails applications with Apache Bench is a breeze. If you are on a Linux machine, all you need to do is install apache2-utils and feed AB with something to “chew”. For the sake of simplicity, I prepared a sandbox [Spree 1.1](https://github.com/spree/spree/tree/1-1-stable) running on:

- Ruby on rails 3.2.3,
- Ruby 1.9.3-p194,
- the Thin web server,

to facilitate the demonstrations that follow. The landing page of the aforementioned application can be found [here](https://gist.github.com/2868446). Let’s see what happens if we type in the following command
in the console:

`$ ab -n 250 -c 25 ` [http://localhost:3000/](http://localhost:3000/)

I have instructed Apache Bench to send 250 requests in total and to perform 25 requests at a time. Let’s carry on:

	This is ApacheBench, Version 2.3 <$Revision: 655654 $>
	Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
	Licensed to The Apache Software Foundation, http://www.apache.org/
	
	Benchmarking localhost (be patient)
	Completed 100 requests
	Completed 200 requests
	Finished 250 requests
	
	Server Software:        thin
	Server Hostname:      localhost
	Server Port:                3000
	
	Document Path:         /
	Document Length:      12722 bytes
	
	Concurrency Level:   25
	Time taken for tests:   60.947 seconds
	Complete requests:    250
	Failed requests:         0
	Write errors:               0
	Total transferred:        3332250 bytes
	HTML transferred:      3180500 bytes
	Requests per second:           4.10 [#/sec] (mean)
	Time per request:       6094.710 [ms] (mean)
	Time per request:       243.788 [ms] (mean, across all concurrent requests)
	Transfer rate:             53.39 [Kbytes/sec] received
	
	Connection Times (ms)
	            min  mean[+/-sd] median   max
	Connect:         0          0   0.2              0          1
	Processing:  3768 5973 906.9   6069           7843
	Waiting:           267 4418 1280.4   4671         6086
	Total:               3768 5974 906.9   6070         7843
	
	Percentage of the requests served within a certain time (ms)
	 50%   6070
	 66%   6083
	 75%   6087
	 80%   7041
	 90%   7314
	 95%   7576
	 98%   7773
	 99%   7843
	100%   7843 (longest request)

That was easy. **Yet remember to run a test at least several times and compare the results to make sure you have eliminated any random factors from your benchmark. Test your Ruby on Rails application in a real (or close to real) production environment. Keep the network configuration and html partial identical for the purpose of testing and creating baselines**. The above tips apply to any form of web application benchmarking. I have added this notes above as people tend to pay a lot of attention to the numbers, while what actually matters is the general approach they adopt.

## [JMeter](http://jmeter.apache.org/)

JMeter is a performance benchmark written in Java which “[can be used to simulate a heavy load on a server, network or object to test its strength or to analyze overall performance under different load types](http://jmeter.apache.org/).” A huge number of options and features available may seem overwhelming at first, but a good [introduction](http://lincolnloop.com/blog/2011/sep/21/load-testing-jmeter-part-1-getting-started/) into the topic will help you find the way. For the purpose of presenting JMeter, I prepared a scenario whereby the users swarm the sandbox RoR application, navigate to the homepage and view a featured product. I grouped the actions in a transactions controller and added some listeners to gather some data from the experiment. Good performance testing should not only focus on the metrics such as response time or status code, but it should also assert that the user experience is not affected by excessive loads in any other way. Luckily, JMeter allows to set such expectations in testing scenarios. I also really liked the Jmeter interface which allows one to drag and drop the test elements while managing test suites – see the attached screenshot.

![](images/jmeter_better-1024x537.png)

What is nice about JMeter is that it will run in any environment with Java implementation. Thanks to JVM it is possible to achieve concurrent sampling by using many threads as well as the continuous sampling of different functions running in separate thread groups. The biggest con of JMeter is that it can significantly strain the system resources.

[Tsung](http://tsung.erlang-projects.org/)

As we saw with JMeter, programming languages with baked-in threading and concurrency are strong contenders when it comes to creating performance benchmark tools. Tsung (formerly IDX-Tsunami) has been developed in Erlang – a concurrency-oriented programming language. Tsung is protocol-independent and can currently be used to stress HTTP, WebDAV, SOAP, PostgreSQL, MySQL, LDAP, and Jabber/XMPP servers. Like JMeter, Tsung allows you to build complex “user stories” with extended reports.
Although Tsung has an extensive [documentation](http://tsung.erlang-projects.org/user_manual.html), I have not found a good tutorial that would show “how to start from scratch”. I hope the few tips in the passage that follows will help you become familiar with the tool.  If you are on a Linux machine, try to download an appropriate package from the [Tsung homepage](http://tsung.erlang-projects.org/) and install it. Then just cd into the tsung examples directory by issuing the command:

	`cd ~/tsung-<<insert your version here!>>/examples/`

You now gain access to handy examples presenting the various scenarios for performance testing with Tsung. I should mention a very interesting feature of Tsung: you do not have to write scenarios down, you can just record them!

![](images/tsung-graph.png)

Tsung allows us to record our sessions (instead of writing them down). In order to do so, we first need to instruct the browser to pass through a proxy listening to port 8090 (if you are using Firefox: Preferences – Advanced – Network – Settings). After the http_session is configured, just run:

	tsung recorder

and then

	tsung stop_recorder

to catch the results in *~/.tsung/tsung_recorderyyyymmdd-HH:MM.xml*  location. Next, all we have to do is to copy paste the recorded session into the main tsung xml file, and run it by issuing:

	tsung start

After the benchmark is complete, we run the tsung_stats.pl script to make the report.html readable from the benchmark results.
Tsung for sure is a great tool, but it it does not score very high as regards user friendliness. A better graphic interface would definitely help Tsung ensure a more pleasant user experience.

## [httperf](http://www.hpl.hp.com/research/linux/httperf/)
Httperf is a tool that generates workloads to test HTTP servers. Httperf features include:

- think times (a nice option that allows you to mimic real user behavior),
- url generation,
- burst support,
- GET/POST queries in the session file,
- different concurrency rates.

Htttperf was originally developed for Hewlett-Packard and open sourced only after some time. Just as Apache Benchmark, it can be run from the console. For example, the following command:

	`httperf –hog –server=127.0.0.1 –port=3000 –wsess=100,5,3 –rate=2 –timeout=5`

generates a total of 100 sessions at a rate of 2 sessions per second. Each session consists of
5 calls that are spaced out by 3 seconds. From all the benchmarks I have seen, finding the saturation point of a given Ruby on Rails application is the easiest with httperf.  Here is some sample output:

	httperf –hog –timeout=5 –client=0/1 –server=127.0.0.1 –port=3000 –uri=/ –rate=2 –send-buffer=4096 –recv-buffer=16384 –wsess=100,5,3.000
	httperf: warning: open file limit > FD_SETSIZE; limiting max. # of open files to FD_SETSIZE
	Maximum connect burst length: 1
	
	Total: connections 100 requests 169 replies 74 test-duration 60.984 s
	
	Connection rate: 1.6 conn/s (609.8 ms/conn, <=29 concurrent connections)
	Connection time [ms]: min 11100.2 avg 16389.6 max 26983.4 median 14637.5 stddev 4902.7
	Connection time [ms]: connect 0.0
	Connection length [replies/conn]: 2.242
	
	Request rate: 2.8 req/s (360.9 ms/req)
	Request size [B]: 62.0
	
	Reply rate [replies/s]: min 0.0 avg 1.2 max 2.8 stddev 1.0 (12 samples)
	Reply time [ms]: response 2618.7 transfer 0.0
	Reply size [B]: header 612.0 content 12722.0 footer 0.0 (total 13334.0)
	Reply status: 1xx=0 2xx=74 3xx=0 4xx=0 5xx=0
	
	CPU time [s]: user 32.60 system 19.88 (user 53.5% system 32.6% total 86.1%)
	Net I/O: 16.0 KB/s (0.1*10^6 bps)
	
	Errors: total 95 client-timo 95 socket-timo 0 connrefused 0 connreset 0
	Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0
	
	Session rate [sess/s]: min 0.00 avg 0.08 max 0.20 stddev 0.06 (5/100)
	Session: avg 1.00 connections/session
	Session lifetime [s]: 25.5
	Session failtime [s]: 7.9
	Session length histogram: 67 13 9 6 0 5

I find the httperf output a little bit more informative than that delivered by, for instance, Apache Bench. Httperf also seems to be richer in terms of features. It is definitely worth a trial.

## [httpload](http://www.acme.com/software/http_load/)

By rule of thumb you should not run load / stress testing benchmarks on the same machine you run a Web Server on. Removing the network factor can lead to false expectations as to what the end-user experience is like. Besides, frequent benchmark runs are resource intensive. Your can skew your results if there is competition for system resources between the benchmark tool and your Ruby on Rails application. Still if for a reason the network infrastructure is of no concern for you, you may arrive at solid results by using a benchmark tool that is generally considered ‘lightweight’; lightweight enough to run on the same machine with your application. For this reason  I picked http_load – a multiprocessing http test client; it runs in a single process and, therefore, it does not bog down the client machine.
Httpload has not been actively developed for some time now, but I found a fork of the project with a very good readme. Here is some sample output:

	socjopata@socjopata-pc:~$ httpload -rate 10 -seconds 60 url.txt
	205    0    53258    3000259    31429676    200
	206    0    53259    3000326    31336053    200
	232    0    53285    3000391    31371277    200
	221 fetches, 379 max parallel, 2.81156e+06 bytes, in 60.0003 seconds
	12722 mean bytes/connection
	3.68332 fetches/sec, 46859.2 bytes/sec
	msecs/connect: 108.609 mean, 3000.39 max, 0.121 min
	msecs/first-response: 18502.2 mean, 38271.5 max, 258.467 min
	HTTP response codes:
	 code 200 — 221

I have not removed anything out of the output. As you can see, there is little data to examine here. When it comes to testing philosophy and features, httpload is very close to Apache Bench: it does only throughput tests, which, in my opinion, are suitable for some purposes. However, Apache Bench output provides more useful information. Httpload is more like DOS attack; it generates a specified number of requests every second without waiting for the previous requests to complete. The process can generate a lot of noise in your server log files as the web server may fail to answer non-existent requests.

## [Trample](http://jamesgolick.com/2009/6/4/introducing-trample-a-better-load-simulator.html)
![](images/featured-2.png)
Being a Ruby programmer, I could not escape the feeling that some other fellow Rubyist must have tackled the problem “in a Ruby way” before. “**Wouldn’t it be great to be able to write performance and load testing scenarios in the same manner as we write our test suites with Rspec, Capybara and the like?**”
My gut feeling led me to discover Trample. Find an up-to-date fork of the project [here](https://github.com/jumph4x/trample). Trample is a load simulator whose main advantage is the randomization of the requested urls. The characteristic allows to mimic real world traffic more closely.

I had some trouble installing Trample as the gem gets installed without dependencies. The moment I sorted it out, I started writing my first load test in Trample:

	Trample.configure do
	 concurrency 5
	 iterations 10
	 get “127.0.0.1:3000″
	 get “127.0.0.1:3000/login”
	 login do
	            post “127.0.0.1:3000/users/sign_in” do
	            {:user_email => “socjopata@gmail.com”, :user_password => “secret”}
	            end
	 end
	end

Running a performance test is as simple as invoking trample start filename.rb in the console.
Trample looks promising, but it lacks a few things:

- a way to present the test results in a sensible manner; the current output from the console is far from informative;
- the ability to group requests in a transactions; something similar to JMeter transaction controller, for instance. Trample requests are fired up in random order.
- cookie and session management (present in JMeter).

**Still the idea to write  performance / load and stress tests in a way one writes unit and integration tests is powerful**. If anyone knows about similar solutions for Ruby, share the knowledge in the comments section below the post, please.
**A follow-up to the benchmarking tools comparison: web applications performance management tools**.

If you are doing performance tuning or you just want to keep track of  your application performance over time, the ability to display and compare the results obtained is a significant factor to consider when selecting a benchmark tool for a Ruby on Rails application. Choose benchmarks which facilitate creating [baselines](http://www.businesstechnologyarticles.eu/designing-load-performance-test-suites-for-ruby-on-rails-applications-part-one).

It is also a good idea to include web application performance monitoring and management tools in the performance test suite for a Ruby on Rails application. The tools like [New Relic](http://newrelic.com/) operate on real production data and provide real time insights into:

- response time and throughput,
- errors and availability,
- user satisfaction,
- server resource utilization.

Although the tools like New Relic cannot provide the information gathered during performance / load and stress testing, **you can use New Relic to validate and further improve your performance test suite. With such tools at hand you obviously gain the regular benefits of 24/7 monitoring of your application performance in the production environment**.

## Summary
I hope this blog post together with the previous article on designing performance / load test suites shed some light on the common problems and solutions that Ruby on Rails development teams face while designing and running performance test suites for their applications.

**There are different tools for different jobs**. If you need to conduct simple throughput testing and/or measure the responsiveness of particular pages in the system, the tools like Apache Bench or httperf will do the trick. If, however, your performance test suite is to reflect the business logic of the application, you should look for tools like JMeter, i.e., those which allow you to combine requests into transactions creating “user stories”.

The choice of benchmarking tools is often a compromise between **a number of factors such as: ease of use, features, and time needed to prepare and maintain a test suite**. You may find out that, for example, a tool delivers outputs which are very useful and easy to read, but, unfortunately, it is unable to saturate your web application in a desired way, or has other limitations which do not satisfy your requirements.

While experimenting with benchmarks, you should limit yourself to using a limited number of them. The greatest value of benchmarking comes from the ability to compare the application performance parameters over time. Stick to the key issue and you may be able to use the right number of tools. Creating and maintaining tests suites for different benchmarking tools increases the costs of performance testing, the costs which may not necessarily be offset by the associated benefits.