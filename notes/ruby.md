# Ruby notes

## Bundler
#### [bundle open](http://blog.jerodsanto.net/2012/07/my-favorite-bundler-feature/?utm_source=rubyweekly&utm_medium=email)
Having used Bundler long enough to take its dependency management feature for granted (snark), I've come to know and love another feature of Bundler: `bundle open`

What does `open` do? It opens a bundled gem in your editor. Simple as that.

Want to toss some debug output inside an ActiveRecord query chain?

     bundle open activerecord

Would it just be easier to throw a `binding.pry` right inside Mongoid's call chain? (Pro tip: yes, yes it would)

      bundle open mongoid

`bundle` open reduces the friction of diving into my dependencies, which means I do it sooner and more often.

