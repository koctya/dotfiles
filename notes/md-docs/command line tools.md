## command line tools for web developers

Life as a web developer can be hard when things start going wrong. The problem could be in any number of places. Is there a problem with the request your sending, is the problem with the response, is there a problem with a request in a third party library you're using, is an external API failing? There are lots of different tools that can make our life a little bit easier. Here are some command line tools that I've found to be invaluable.

**Curl** Curl is a network transfer tool that's very similar to wget, the main difference being that by default wget saves to file, and curl outputs to the command line. This makes is really simple to see the contents of a website. Here, for example, we can get our current IP from the ifconfig.me website:

    $ curl ifconfig.me
    93.96.141.93
Curl's -i (show headers) and -I (show only headers) option make it a great tool for debugging HTTP responses and finding out exactly what a server is sending to you:

    $ curl -I news.ycombinator.com
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Cache-Control: private
    Connection: close
The -L option is handy, and makes Curl automatically follow redirects. Curl has support for HTTP Basic Auth, cookies, manually settings headers, and much much more.

**Siege** Siege is a HTTP benchmarking tool. In addition to the load testing features it has a handy -g option that is very similar to curl -iL except it also shows you the request headers. Here's an example with www.google.com (I've removed some headers for brevity):

    $ siege -g www.google.com
    GET / HTTP/1.1
    Host: www.google.com
    User-Agent: JoeDog/1.00 [en] (X11; I; Siege 2.70)
    Connection: close
    
    HTTP/1.1 302 Found
    Location: http://www.google.co.uk/
    Content-Type: text/html; charset=UTF-8
    Server: gws
    Content-Length: 221
    Connection: close
    
    GET / HTTP/1.1
    Host: www.google.co.uk
    User-Agent: JoeDog/1.00 [en] (X11; I; Siege 2.70)
    Connection: close
    
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=ISO-8859-1
    X-XSS-Protection: 1; mode=block
    Connection: close

What siege is really great at is server load testing. Just like ab (apache benchmark tool) you can send a number of concurrent requests to a site, and see how it handles the traffic. With the following command we test google with 20 concurrent connections for 30 seconds, and then get a nice report at the end:

    $ siege -c20 www.google.co.uk -b -t30s
    ...
    Lifting the server siege...      done.
    Transactions:                    1400 hits
    Availability:                 100.00 %
    Elapsed time:                  29.22 secs
    Data transferred:              13.32 MB
    Response time:                  0.41 secs
    Transaction rate:              47.91 trans/sec
    Throughput:                     0.46 MB/sec
    Concurrency:                   19.53
    Successful transactions:        1400
    Failed transactions:               0
    Longest transaction:            4.08
    Shortest transaction:           0.08

One of the most useful features of siege is that it can take a url file as input, and hit those urls rather than just a single page. This is great for load testing, because you can replay real traffic against your site and see how it performs, rather than just hitting the same URL again and again. Here's how you would use siege to replay your apache logs against another server to load test it with:

    $ cut -d ' ' -f7 /var/log/apache2/access.log > urls.txt
    $ siege -c<concurreny rate> -b -f urls.txt

**Ngrep** For serious network packet analysis there's [Wireshark](http://www.wireshark.org/), with it's thousands of settings, filters and different configuration options. There's also a command line version, tshark. For simple tasks I find wireshark can be overkill, so unless I need something more powerful, ngrep is my tool of choice. It allows you to do with network packets what grep does with files.

For web traffic you almost always want the `-W` byline option which preserves linebreaks, and `-q` is a useful argument which supresses some additional output about non-matching packets. Here's an example that captures all packets that contain GET or POST:

    ngrep -q -W byline "^(GET|POST) .*"

You can also pass in additional packet filter options, such as limiting the matched packets to a certain host, IP or port. Here we filter all traffic going to or coming from google.com, port 80, and that contains the term "search".

    ngrep -q -W byline "search" host www.google.com and port 80

Posted on 13 Aug 2011