
## [HAML: the unforgivable sin](http://opensoul.org/blog/archives/2011/11/30/haml-the-unforgivable-sin/)

### Easy to write, hard to read
I agree that HAML is easier to write than HTML, simply because it involves less typing. But I feel it is infinitely harder to read. While the indentation makes it easy to see the nesting, the extremely overloaded synax requires careful attention to each line.

> Matt November 30, 2011
So I discussed this with everyone at my company and we collectively decided that this entire sentiment is incorrect.

> I like HAML ( or even better SLIM ) because it directly represents what HTML ultimately results in; a DOM. SLIM and HAML have a similar representation as to what you see in a DOM inspector.

> I like HAML because I find it easier to both read and write than HTML.

> Ryan McGeary November 30, 2011
I have to disagree. I agree that HAML isn’t as much of an abstraction as CoffeeScript or SASS (btw, I also love CoffeeScript and prefer SASS over SCSS), but the “easy to write, hard to read” sentiment couldn’t be further from the truth for myself (and likely others that enjoy HAML).  Most of HAML’s syntax is borrowed from CSS selectors which helps remove the cognitive dissonance that results between HTML and CSS.  This is part of the abstraction of HAML that does allow you to get closer to the problem at hand — rendering a beautiful view or layout. To me, HTML adds enough cruft to the underlying data, and ERB adds even more.  HAML cuts that all away allowing for a more concise view, and in my opinion, a much easier-to-read syntax.

> Gabe Varela November 30, 2011
We’ve been using HAML for almost 3 years now. I was very resistant to it initially for the exact reasons you listed in your post. But, my team was insistent in using it back in the early days so I obliged. After the first several projects I began to actually find HAML more descriptive. When you are trying to write semantic html and you are looking through javascript and CSS and relating it back to the HTML, it is much easier in HAML to find the dom elements because you aren’t parsing attributes in a sea of div tags. HAML distills the meaningful parts of your markup down to what is important. I’m 100% sold on HAML now.

> To me, ERB is the thing that is hard to parse, with all the close tags everywhere,

> Zohar Arad November 30, 2011
I agree that initially HAML is a bit odd to write, when you’re used to plain HTML with ERB tags. I was also a bit hesitant to use it at first and I do love writing plain old HTML.
  However, once I got my head around it (thanks to a bit of Python experience), it seems to me there are some notable added values to HAML over ERB:
- Tags are always closed. I don’t need to worry about closing order
- Code blocks are always closed (try finding the <%end%> tag in your ERB spaghetti)
- Complex attributes are cleaner to write since you don’t mix HTML with inline Ruby code
- Separation of markup and Ruby code is clearer because there’s no ERB tag clutter
I think that your assertion that HAML should offer abstraction is a bit misguided, as its simply another template engine and like many other great things in the Ruby world, you either love it or you hate it :)

> Thomas van der Pol November 30, 2011
For the sake of disclosure I should state I’ve only used raw HTML, ERB and HAML.
With that said, I love HAML. There’s so much noise in reading HTML (and ERB is barely better) that scanning HAML is lovely in comparison. I don’t think I have a single problem with it that I can’t lay at the feet of HTML also. I like that it fails early – I can’t forget to close a tag, I can’t be unclear about the parent / child relationship between any two elements, if HAML parses chances are good (or at least much better, for me personally, than with handwritten HTML) that it does what I intend it to.

> Bradley Herman November 30, 2011
I’ve actually found HAML much easier to write AND read through.  SLIM, however I’ve found harder to quickly parse visually, so reading it is a lot slower IMO than reading HAML.

> matt briggs November 30, 2011
I find HTML encourages you to think about the DOM as an XML document, while HAML encourages you to think about it as a tree of nodes with types, classes, and ids. As web developers, we should be thinking about it the second way, which is the biggest reason it resonates with me. The other thing is if you are using sass, there is this really nice symmetry between the way your styling file looks, and your markup file looks.
That being said, I am starting to dump haml as well, but for moustache. I find moustache has a very elegant syntax, keeps me honest with keeping logic out of the view, and most importantly is pretty much the same thing on both client and server side.

> Daniel Huckstep November 30, 2011
The problem is that browsers will parse and display syntactically invalid HTML.
Sometimes they display what you want, other times (okay let’s face it, any time in IE) it displays garbage, and it’s a pain to debug. Haml either compiles or it doesn’t, and it generates correct HTML.
I like Haml because I dislike angle brackets, and I dislike subtle HTML bugs.

> Mike Bethany February 7, 2012
“Typing is not my bottleneck in coding. Thinking is. And forcing my brain to parse HAML when it is occupied by more important things is not conducive to productivity.”
Excellent point. Typing isn’t my bottleneck either but parsing out all the noise in HTML is.
It takes me a fraction of the time to read HAML than it does to read HTML for the simple reason that it’s cleaner. I can better see the meat of the context without all the redundant noise and often poorly formated HTML.
Which brings up another reason why I like HAML so much. It forces people to write clean code. One of the first things I have to constantly do when reading almost anyone else’s HTML is clean it up and fix indentation. With HAML you are forced to write consistently clean code. I like that.

## [Why I Use Haml](http://damiannicholson.com/2011/04/19/why-i-use-haml.html)

If you’d asked me six months ago my stance on alternative templating engines, you would have heard me say something along the lines of ‘I can’t see the point in them. Why do I need to learn another DSL when I’m perfectly comfortable writing ERB.’ To be fair, I bet a lot of developers still feel the same way.

If you were to ask me that question now however, my answer would be completely different. That’s right, I’m a convert. My off the cuff views on templating frameworks have turned full circle.

### How did this happen? Let me explain.

About a month ago I was scanning through my feeds when I came cross yet another blog post outlining the benefits of Haml. For a long time I couldn’t quite understand why so many luminaries I admired in the Rails world were opting to **only use Haml** on their projects.

I decided enough was enough, and I had to give Haml a try. Though rather than starting a fresh project, I decided I wanted to give it a try out on this here blog(my test bed for most new stuff I want to try out). I thought this was an ideal approach as it’s a real world Rails app in production, so I had a benchmark of what the finished product should be like. It also meant that I could merge my Haml feature branch in to master, should I prefer it in the long run(which is what I ended up doing).

### Converting Erb to Haml

Fortunately, the task of converting my ERB views to Haml was straight forward as I found a handy [rake script](http://screencasts.org/episodes/using-haml-with-rails-3) to take care of this. I honestly thought this step would have taken longer, but I was up an running with Haml in a couple of minutes.

### Erb vs Haml

Once I started digging in the code, it immediately became apparent to me as to why Haml has received so much attention over the past year or two. Simply because HAML RAWKS and here’s my attempt to explain why.

### Haml is very lean and concise

So lean that most of my template files were reduced by at least a third in size. In some cases more like 50 − 60%. And the original markup was already lean to begin with. Check out my main layout file – it used to be 70 lines long, now it’s half that(I’ve taken out the includes for brevity).

    %body#body{:class => body_classes}
      .container_12
        %header
          %h1
            %a{:href => root_path }><
              damiannicholson
              %span.strapline web developer // diet coke drinker // master mitigator
        #main.grid_7.alpha
          = yield
        %aside#right.grid_4.push_1.omega
          = render :partial => 'other/bio'
          = yield :sidebar_right
      %footer
        = render :partial => "streams/stream", :collection => @stream, :as => :stream
        #footer-bottom
          .container_12
            %p
              Site built and designed by Damian Nicholson. Powered by Ruby on Rails. //
              %a#scrollto{:href => "#body"} Top

### Expressive and easy to digest

This is a byproduct of Haml being so lean in my opinion – it’s easy to get a good overview of a template in a glance, even if your not familiar with the project. Far easier to absorb than its ERB counterpart which can quite easily become tag soup, especially in larger files like layouts.

### Less typing

Which means that you can spend more time building stuff that matters – my only niggle is that it I’m always shifting for the percentage key(would be nice if this could be mapped to something else like Slim is also awesome btw).

### Easy to spot code smell

Because Haml is concise, it’s easy to spot code that’s doing too much. Therefore moving this logic in to helpers seems to be a natural side effect of the framework itself. I can only see this as a good thing, as it makes refactoring easier.

### Works even better in a team environment

Personal HTML style and formatting practices become obsolete as everyone has to adhere to the same standard. That way everyone writes code which is maintainable.

### Performant

Production mode is all about performance as the outputted HTML is stripped of formatting or indenting by default. I like this.

### Conclusion

> Stop using the slow, repetitive, and annoying templates that you don’t even know how much you hate yet.

This was taken directly from the Haml homepage, and I can certainly relate to the message that’s being conveyed. If anything I hope this post encourages a few readers to take a look at Haml, and how it’s been a great addition to my development toolkit.
