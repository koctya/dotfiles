
# Article Link Archives


## Languages
- [Communicating sequential processes](http://en.wikipedia.org/wiki/Communicating_sequential_processes)
- [Does Functional Programming Replace GoF Design Patterns?](http://stackoverflow.com/questions/327955/does-functional-programming-replace-gof-design-patterns)

### CoffeeScript

### Go
- [How to use interfaces in Go](http://jordanorelli.tumblr.com/post/32665860244/how-to-use-interfaces-in-go)

### Ruby
- [I like Unicorn because it's Unix](http://tomayko.com/writings/unicorn-is-unix)

### Rust
- [The Rust Language Tutorial](http://dl.rust-lang.org/doc/0.4/tutorial.html)
- [Rust (0): Index and Conclusion](http://winningraceconditions.blogspot.com/2012/09/rust-0-index-and-conclusion.html/)
- [Why does Rust compile slowly?](https://mail.mozilla.org/pipermail/rust-dev/2012-October/002462.html)
- [Such a Little Thing: The Semicolon in Rust](http://lucumr.pocoo.org/2012/10/18/such-a-little-thing/)
- [Meal, Ready-to-Eat: A Web Framework for Rust](http://erickt.github.com/blog/2012/07/05/meal-ready-to-eat-a-web-framework-for-rust/)
- [Experimental JIT Compiler for Rust](http://blog.z0w0.me/posts/2012/09/01/experimental-jit-compiler-for-rust/)
- [Refining Traits and Impls](http://smallcultfollowing.com/babysteps/blog/2012/10/04/refining-traits-slash-impls/)
- [Unique Pointers Aren't Just About Memory Management](http://pcwalton.github.com/blog/2012/10/03/unique-pointers-arent-just-about-memory-management/)
- [Rust Protocols Tutorial](http://theincredibleholk.wordpress.com/2012/08/17/rust-protocols-tutorial/)

### Lisp

- [Ooh! Ooh! My turn! Why Lisp?](http://smuglispweeny.blogspot.com/2008/02/ooh-ooh-my-turn-why-lisp.html)


#### From Stackoverflow

I have been working in Erlang for a little while now and so far I really like the concurrency and reliability features. It is a great niche language for writing scalable fault-tolerant distributed systems.

My impression is that Go (by Google) and Rust (by Mozilla) are also targeted towards building concurrent scalable systems. Specifically Rust, which seems to be influenced significantly by Erlang among other languages.

I have a few specific questions contrasting the three languages:

    Do the goals/intended use case of Go, Rust and Erlang overlap?
    How do the goals/intended use case differ (if at all)?
    What features (if any) of Go and Rust make them more suitable than Erlang for writing large scalable systems?


Both, Erlang and Go are heavily influenced by the CSP book by C. A. R. Hoare. There are some minor conceptual differences though, since Erlang is based on an earlier draft of that document.

For example, each Erlang process has exactly one message queue, but Go on the other hand offers separate channel type. Message dispatchers (i.e. multiple processes reading from a single work queue) are therefore easier to implement in Go, but other tasks were one queue is sufficient are a bit shorter in Erlang. Message passing in Erlang is asynchronous, Go's channels on the other hand can be either synchronous (buffer-size = 0) or asynchronous.

Go's concurrency primitives are targeting mainly multicore systems, Erlang on the other hand also supports VMs running on different hosts. You can implement similar things in Go by using the netchan or the rpc package directly and the result is probably much more efficient, but it's also more work. One nice feature about Go is that you are not limited to those CSP primitives for synchronizing concurrent tasks. There is also a very good Mutex implementation as well as lot of atomic primitives for accessing shared memory concurrently.

There are of course a lot of other differences. Erlang is a functional language and Go are structured one. Go is more modern, has a great type system (and a string type *g*) and allows more control over the system, e.g. control over the memory alignment. Erlang programs on the other hand are probably shorter and more abstract. Also, Erlang has been around for a very long time and there are already some really good libraries available. Especially the OTP is a huge advantage of Erlang.

Personally, I am very happy with the choices of the Go team and the Go programming language in general, but it's really hard to tell which one is better. I can't say anything about Rust yet since I haven't really tried it yet.

> Erlang follows indeed the actor model more closely. On the other hand I think that Go's implementation of the CSP model has also some characteristics of the actor model since it supports asynchronous channels and a "select" statement to retrieve messages fairly from a couple of channels. But it's probably not that easy to strictly classify those languages since neither of them follow the papers in a formal way. Oh, and I know that Erlang supports mutlicore as well as distributed systems. That's why I have written "also" :)

I don't know that much about Erlang or Go, but I am familiar with Rust.

They all have similar use cases and goals. Rust is intended for developing fast, safe, concurrent, and large systems. It is specifically being designed for building highly-concurrent browser architectures, where safety is paramount and code size is fairly massive.

Rust very often looks to Erlang when making decisions about concurrency. The concurrency model is still evolving but I would expect it to become more similar to Erlang. There are not yet any plans for hot code swapping in Rust. It also does not yet have any support for out-of-process message passing, but that will almost certainly appear eventually.

Rust tries to integrate with the system toolchain as appropriate for the platform, producing native executables and libraries. It has no JIT option. It is a lower level language than Erlang.

Go and Rust fill a very similar niche, both intended to be concurrent systems languages. My impression (having never used Go) is that they feel somewhat different. Probably the most significant difference between them is that Rust does more than Go to enforce memory-safety, like disallowing null pointers and shared mutable state.

The primary advantage of Rust over Erlang will be developer ergonimics. Rust tries to present things in a way that is mostly-natural to C and C++ programmers while being much safer than either. It has some functional leanings, but it also allows code in a mutating, imperative style that more people are comfortable with.

Rust has a long way to go before it is as mature and reliable as Erlang. It will not 'replace' it in the near future.


    What features (if any) of Go and Rust make them more suitable than Erlang for writing large scalable systems?

Both Go and Rust are statically type compiled language while Erlang is a dynamic language. There is an argument that type checking is crucial in writing large scalable systems.

    Are Go and/or Rust serious contenders to replace Erlang in the near future?

Rust is built to replace C++, and is suitable for system programming work. Go is more of a Python/Java contender in term of its ease of use. Rust and Go are similar in terms of its language syntax and low levelness. Erlang is functional and concurrent. I doubt any language will 'replace' another one. The other language that is both functional and concurrent is Clojure. Some says Clojure is the new Erlang.

Both Go/Rust are relatively new compared with Erlang and none has its maturity. Rust is still a beta software but does look very promising.


>        Do the goals/intended use case of Go, Rust and Erlang overlap?
        How do the goals/intended use case differ (if at all)?

Yes, they do overlap, as all 3 are languages designed around/toward concurrency.

They also differ though, which is where it gets interesting:

>    Erlang high availability is built-in, its hot reload capabilities are unmatched in the other two languages. It is also a dynamically typed language.   Go was meant to build servers while Rust was meant to build concurrent applications. This is clearly reflected in the design choices that have large effects on performance (no introspection in Rust while it's routinely used in Go to cast between interfaces).

I would note that the high availability feature of Erlang is central to its use in phone switches.

> What features (if any) of Go and Rust make them more suitable than Erlang for writing large scalable systems?

In general, I have found statically typed languages are better to write large systems simply because it is easier to write tools for them.

grep only works so far when looking for all callers of a given method: as soon as the method name is pretty generic (Python's len ?), then you have to wade through hundreds or thousands of candidates.

> Are Go and/or Rust serious contenders to replace Erlang in the near future?

I expect Rust to be a no-brainer for applications if it gains at least as much maturity as Go (compared to the two others, I don't expect it to replace Java so soon).

On the server side though, it's a bit more complicated. Rust is better engineered that Go (as much as I appreciate Pike's talks): much safer, more modular. A comparison to Erlang however is difficult, they are just different.

All in all I would expect Rust to displace Go if it ever reaches maturity, but I don't think it will conflict much with Erlang: they are too different.
