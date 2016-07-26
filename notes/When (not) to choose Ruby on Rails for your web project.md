#When (not) to choose Ruby on Rails for your web project

MAY 29, 2012 BY [IRENEUSZ SKROBIŚ](http://www.businesstechnologyarticles.eu/author/irekskrobis)     

##The Origins of Ruby on Rails

It is not unusual for a new technology to originate from a successfully developed project. For example, we can find the pattern in the story of a web framework for Python - Django, which was originally developed to manage a number of news-oriented sites for the LJworld company. It was also the case with [Ruby on Rails](http://rubyonrails.org/), which was extracted from the codebase of a popular project management and online collaboration software tool - [Basecamp](http://www.basecamp.com/) – by its creator, [David Heinemeier Hansson](http://david.heinemeierhansson.com/) ([@DHH](http://twitter.com/#%21/DHH)).



[Ruby on Rails](http://rubyonrails.org/) (RoR), is an open source full-stack web application framework built on top of the Ruby programming language, leveraging the [Model/View/Controller](http://en.wikipedia.org/wiki/Model-View-Controller) (MVC) architecture pattern.  Ruby on Rails was originally released in July 2004 and we have had nine major version bumps since then. The current version shipped with number 3.2 in January 2012. Over the years, Ruby on Rails has grown when it comes to the number of features allowing developers to achieve more in less time. Still, during all those years, the main principles of Rails – the same principles that led DHH to create the framework – have remained unchanged. The “[Convention over Configuration](http://en.wikipedia.org/wiki/Convention_over_Configuration)” (CoC), and “[Don’t Repeat Yourself](http://en.wikipedia.org/wiki/Don%27t_Repeat_Yourself)” (DRY) principles are as important nowadays as they were back in 2004.

“Convention over Configuration” is a software design paradigm that encourages  developers to focus on “what they are doing ” instead of on “how they are doing it”; the approach is meant to boost their productivity. The DRY principle in turn is defined in the following way: “Every piece of knowledge must have a single, unambiguous, authoritative representation within a system”, which, in plain English, means: keep your business logic in one place. Following the DRY concept, makes the introduction of changes to the Ruby on Rails application a relatively fast and simple process.

#Ruby on Rails – strengths and weaknesses

Ruby on Rails, like any tool, has to pay its way. No technology is a silver bullet though; each comes with its strong and weak points and must be used properly to achieve the desired results. So, where does Ruby on Rails really shine?

##Ruby on Rails pros:

####Development speed

It looks like **Ruby on Rails has a lot to offer when it comes to development speed**. [Yukihiro Matsumoto](http://en.wikipedia.org/wiki/Yukihiro_Matsumoto) ([@yukihiro_matz](https://twitter.com/#!/yukihiro_matz)), the creator of the Ruby language, once noted that he designed Ruby with **programmer productivity and fun** in mind. Ruby follows the [principle of least astonishment](http://en.wikipedia.org/wiki/Principle_of_least_astonishment) (POLA). It means that the language should behave in such a way as to minimize confusion for its users. That was in fact Matz’s major design **goal: to create a language which he himself would enjoy using, by minimizing the programmer’s work and possible confusion**.

The story of the foundations of the Rails framework is no different. [David Heinemeier Hansson](http://david.heinemeierhansson.com/) created the web-development framework Ruby on Rails to **free programmers from what he saw as “repetitive coding”**, typical for platforms such as Java, for instance. From the very beginning, Ruby on Rails has emphasized the Convention over Configuration, and the Agile  development principle of Don’t Repeat Yourself. The currently available Rails 3.2.3 version derives directly from Matz’s and DHH’s principles, and substantially improves the developer’s productivity. **It is the inherently reduced workload that is the key factor behind speed – the properties of Ruby on Rails allow to develop (some) apps much faster than with other technologies**.

###Flexibility

**The ability to easily modify a web application in response to customers’/users’ feedback is crucial for entrepreneurs developing new products / web-based ventures**. You can watch an interesting [presentation](http://www.youtube.com/watch?v=IVBVZGfzkVM&t=17m9s) on the topic by [Eric Ries](http://www.startuplessonslearned.com/) (@ericries), the creator of the [Lean Startup methodology](http://www.youtube.com/watch?v=fEvKo90qBns) and the author of The [Lean Startup book](http://theleanstartup.com/book) as well as the [blog Startup Lessons Learned](http://www.startuplessonslearned.com/). In the presentation, Eric is talking specifically about Rails and start-ups (if you want to get straight to the point, watch the part from 17:09’’ to 19:30’’). He shows the value Ruby and Rails has brought to the start-ups world. One of the key benefits is the flexibility of the technology, which allows for easy modifications when, for example, you need to pivot the solution developed. With Rails it is really easy to create applications which incorporate many seemingly unrelated components like a blog, a forum, a cms, e-commerce etc.

###Development cost

If we consider the above mentioned strengths of Ruby on Rails, i.e., the developer’s productivity, the flexibility of the technology, the availability of free, open source components and relate them to development costs, we will see some interesting results. In fact, we will discover yet another benefit of Rails: **for some types of projects, the development cost may be significantly lower** than if they were implemented with less flexible, heavier, or non-open-source technologies, like Java or .Net.

####Ruby on Rails goes hand in hand with “Agile”

**If you believe Agile is the methodology to adopt on your project RoR is the technology which facilitates the approach**. The power of Rails helps to keep development cycles really short and thus facilitates the application of the agile methodologies. Rails is, for example, very [TDD](http://en.wikipedia.org/wiki/Test-driven_development)/[BDD](http://en.wikipedia.org/wiki/Behavior_Driven_Development)-oriented, even to the point where TDD does not feel like an additional task a programmer has to perform in order to achieve the desired results. For some Ruby on Rails programmers following the TDD technique may feel like the only way to work. Therefore, Ruby on Rails is a perfect choice if you want to use the programming methodologies often associated with such techniques as TDD/BDD, i.e., [Agile](http://en.wikipedia.org/wiki/Agile_software_development) or [Scrum](http://en.wikipedia.org/wiki/Scrum_%28development%29).

####Thriving community

This attribute is often underestimated or even – overlooked altogether, because it translates into the strength of the technology only indirectly. No project or initiative can thrive for long without the involvement and contribution of the people surrounding it. Ruby on Rails has a great, passionate community which relentlessly drives the technology forward, developing the Rails framework, introducing enhancements in the form of plugins and extensions, improving the documentation, etc. **Such an established community increases the chances that in a few years’ time, you will still be able to find the people with the skill set needed to further develop / maintain your Rails application**.

##Ruby on Rails cons:

It is somewhat difficult to write about the weaknesses and constraints of Ruby on Rails when you actually are a Ruby on Rails developer. You may have to overcome a natural positive bias that stems from the fact. I shall try. Before writing this part of the article, I had asked several Ruby on Rails developers about the weaknesses and limitations of Rails. I had also gathered the feedback from some PHP, Python and Java developers. On top of that, I had googled to find out “what the Internet says” about the weak points of the technology. In the account below, I purposely omitted some minor differences and technical nuances that developers will argue about for hours, like the point in this example:

A Django developer: We have got an admin panel, and you Rails guys don’t!

A Rails developer: Yes, RoR doesn’t ship with an admin panel, but we can use plugins which enable such functionality.

All in all, I tried to stay within a bigger picture without getting bogged down in details. Here is the list:

###Performance

“Ruby is slow” – I heard that one many times. First, one must acknowledge that the Rails framework, which popularized the Ruby language, dates back to 2004. [Part of the argument may be a thing of the past in 2012](http://yehudakatz.com/2011/06/14/what-the-hell-is-happening-to-rails/). We have got a new YARV interpreter as well as native threads (Fibers) which have helped Ruby to get rid of its “slow poke” stigma. There is the excellent JRuby implementation based on JVM, as well as [Rubinius](http://rubini.us/) where leveraging the power of threading execution is possible. The Ruby community have invested a lot of effort into making Ruby and Ruby on Rails a decent option when it comes to performance. **Therefore, what was true in general in – let’s say – 2007, is not necessarily true today**. Nowadays Ruby is comparable (performance wise) to other dynamic, interpreted languages like Python or Perl. A web application may become a little slow and bloated when it gets bigger, but a good Ruby programmer has the means to tune the performance up if and when needed.

###Poor documentation

Good documentation is a vital part of any project, including a programming language. I heard a lot of voices complaining that Ruby on Rails is lacking proper documentation. The complaints were loud enough to provoke [blog posts](http://rubyonrailsdevelopment.pl/archives/ruby-on-rails-poorly-documented%E2%80%A6-not) and [release notes](http://weblog.rubyonrails.org/2010/8/28/rails-has-great-documentation/) devoted entirely to confronting the criticisms. In principle, the case is similar to the objections concerning Ruby performance. **Ruby on Rails is no longer a poorly documented technology**. Nowadays there are plenty of resources you can pick from, e.g. [RailsTutorial.org](http://ruby.railstutorial.org/), [Rails Guides](http://edgeguides.rubyonrails.org/), Rails API Docs(here and [here](http://apidock.com/rails)), [Rails 3 Free Screencasts](http://railscasts.com/) and many related books.

####Constant, rapid changes of the framework

The fast evolution of Ruby on Rails in the cons section may seem baffling to some. It may imply that technology which does not change is desirable. **There is a price to pay for staying on the edge**. Ruby on Rails has evolved through several major revisions, and each one introduced some incompatibilities between one another. What is more, each major release effectively rendered some existing plugins outdated. Ruby on Rails developers face decisions concerning “how” they want to implement certain features such as, for instance, [authentication](https://www.ruby-toolbox.com/categories/rails_authentication.html), [exception notification](https://www.ruby-toolbox.com/categories/exception_notification), [object-relational mapping](https://www.ruby-toolbox.com/categories/orm), [admin interface](https://www.ruby-toolbox.com/categories/rails_admin_interfaces) etc. If you follow the links you will be redirected to [The Ruby Toolbox](https://www.ruby-toolbox.com/), which lists about 10 different solutions for authentication, 10 for notification, 5 for object-relational mapping and 14 for admin interface (as of today). Besides, each specific solution is burdened with dependencies and can become unpredictably outdated after a new Ruby on Rails version is released. There are often no straightforward answers as to which is the optimum way to go.

All the above combined with Ruby on Rails complexity itself [that requires enormous amounts of peripheral knowledge to understand](http://news.ycombinator.com/item?id=3572856), makes it sometimes difficult for the developer to catch up with the latest changes. Why should it concern you – the entrepreneur – that some programmers may have difficulties catching up? Good developers are very efficient on the Ruby on Rails platform. But good developers are hard to find. And this may be a problem: **Ruby on Rails may be the best technology for your project, but finding good Ruby on Rails programmers may be a challenge**.

####Ruby on Rails framework development is community driven

This is basically a follow up to the previous point. Ruby on Rails is developed by its community. This has a good and a bad side. The bad side is that **there is no formal institution that would take the responsibility for the changes introduced to the framework**. There is no long term roadmap of changes and there are no guarantees when it comes to the support of any kind. This may discourage some companies / institutions from choosing Rails, because Java or .Net, supported by Oracle and Microsoft respectively, may seem to be a “safer”, more solid option. In principle, the bigger the company, the more likely they are to go for the enterprise mainstream technologies backed up by corporate players.

##Web projects / application types suitable for Ruby on Rails
![](http://www.businesstechnologyarticles.eu/files/2012/05/ror.png)
Now that we know the pros and cons of the Ruby on Rails framework, we can try to identify the type of web projects / application types which lend themselves to be developed in Ruby on Rails as well as those for which alternative technologies may be a better choice. Here is the list of web projects / application types, where RoR might be considered as a sound candidate for the tech stack:

- **Custom web applications** – Ruby on Rails can be used to create a number of custom applications such as e-commerce solutions ([Groupon](http://groupon.com/), [Fairdeals](http://www.fairdeals.dk/)), SaaS products ([Basecamp](http://basecamp.com/)) or services with the contents like music, videos ([Funny or Die](http://www.funnyordie.com/)) or streaming ([Hulu](http://www.hulu.com/)).
- **Functionality-rich web services** – if you want to create an application which aggregates a lot of different functionalities such as a multi-sided platform encompassing a community platform, a cms, forums, geolocation, blogs ([HearingPages](http://www.hearingpages.com/)) or a solution with a combination of: a news service, a media content platform, a crm and a community service ([New Your Jets](http://www.newyorkjets.com/)), Ruby on Rails provides you with ample flexibility to account for the richness.
- **Web projects / applications** for which time to market is critical / the [cost of delay](http://www.softwaredevelopmentoutsourcing.eu/cost-of-delay-insights-for-better-product-scope-management/) is high – new ventures which depend on fast execution for success should consider using Ruby on Rails. [Twitter](https://twitter.com/) and [Groupon](http://www.groupon.com/) come to mind as notable examples of ventures created in RoR.
- **Prototyping web applications** – thanks to the speed and the flexibility with which RoR projects can be developed, prototyping seems a most natural opportunity. When you compare the time needed to build prototypes with the tools such as [Axure](http://www.axure.com/), [Balsamiq Mockups](http://www.balsamiq.com/products/mockups) or [Protoshare](http://www.protoshare.com/) to the time required to build an RoR prototype, you will notice that, at the expense of some extra time, you are able to furnish a much more tangible model with the following benefits:
	- real data usage,
	- more reliable findings in usability testing,
	- the ability to change the prototype easily,
	- an opportunity to remove some major risks, e.g. technical risks, from the project implementation, etc.

- **Web projects / applications with poorly defined scope / with scope likely to change during implementation**. Ruby on Rails will stand up strong if you need a web application which is hard to define/specify up-front and which is thus likely to get adjusted while the app is being developed. If you are to build the solution along the lines advocated by [S.G. Blank](http://steveblank.com/) and the **Customer Development Framework**, consider Ruby on Rails as an option. The flexibility that comes with the technology will help a lot to account for the [customers’/users’ feedback](http://www.softwaredevelopmentoutsourcing.eu/customer-driven-product-development-report-from-the-trenches/) as well as to transition the app through the pivots you may be challenged with on the way. RoR paired with Agile methodologies lend themselves naturally to build software “in dialogue with the intended users”.

## Application types that are less suitable for Ruby on Rails

Here is a curated list of application types for which Ruby on Rails may not be the best option to choose. **The application types that have found their way into the list can be built with RoR, but usually  there are just more suitable technologies to implement such projects**. Here is the list:

### Blogs

If you want to create a blog, you should not bother with Ruby on Rails as there are neater and cheaper technologies that have been developed specifically for that purpose, e.g. [WordPress](http://wordpress.org/). It is only when you need a custom solution where a blog is just a part of your product idea that Rails might be chosen to meet the challenge with these [tools](https://www.ruby-toolbox.com/categories/Blog_Engines).

### Content Management Systems

Those are similar to blogs. There are many better and cheaper alternatives to building a CMS, for example, [Joomla](http://www.joomla.org/)! or [Drupal](http://drupal.org/). Still if you intend to build a custom web application where a CMS is only one of the functionalities, the Rails community have created [more than twenty tools](https://www.ruby-toolbox.com/categories/content_management_systems) to enable such functionality within an app.

### Brochure pages

A simple site with information about your company should be built with lighter technologies. If a simple combo of HTML and CSS is not sufficient to meet your needs, check out some CMS-driven solutions or simple static pages generators, e.g. ([Bonsai](https://github.com/benschwarz/bonsai), [MiddleMan](https://github.com/middleman/middleman), http://staticmatic.rubyforge.org/) . You may as well use the Ruby-based [Jekyll](https://github.com/mojombo/jekyll).

### Simple, minimalistic web applications

Although it is possible to create single file applications in Ruby on Rails, I would recommend other technologies for the purpose. A minimalistic light-weight web service might benefit from Werc, [CherryPy](http://www.cherrypy.org/) or [Sinatra](http://www.sinatrarb.com/) – a DSL for creating such web apps in Ruby.

### Generic e-commerce applications

It is less complex and less expensive to build a standard / typical e-commerce service using such tools as [Weebly](http://www.weebly.com/), [Etsy](http://www.etsy.com/) or [Shopify](http://www.shopify.com/). Again, if you want to customize an e-commerce solution for your very specific needs or the e-commerce module is only one of the many features that you need to implement in your solution, [Spree](http://spreecommerce.com/) or other Ruby on Rails [e-marketplace solutions](https://www.ruby-toolbox.com/categories/e_commerce) might be considered.

### Highly secure financial applications

Financial transactions often rely on procedures stored in the software environment and databases which are independent from the web interface. Ruby on Rails is optimized for simple CRUD operations rather than for enforcing complex transactional rules. Therefore, RoR may not be the right tool for the job. The community-driven development of Rails may as well be a reason why Ruby on Rails is rarely used for financial applications development. Java or .Net are supported by big companies like Oracle and Microsoft respectively. There is no large institution to back up Rails in a similar way.

The list above is definitely not exhaustive. There are surely other software development solutions that might be better off if implemented with non-RoR technology stacks. The compilation has been based on the enquiries Selleo have received from their prospects but chose to recommend a non-RoR tech stack for them.

