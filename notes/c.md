# What's To Love About C?

## Slashdot [thread](http://developers.slashdot.org/story/12/07/02/1657206/whats-to-love-about-c?sdsrc=popbyskid)

Don't know much about C, do we? ;-)

He does, you not so much.

If I saw the above declaration, I wouldn't be at all surprised to see a later command like:

post = "second"; // Or perhaps some computed value

If the declaration had contained a const, this would be a syntax error, since the variable post has been declared a constant.

Nopz, what was declared as constant is the memory the pointer is pointing to. Example:

    1: void f() {
    2: const char *a="bla";
    3: a = "blu";
    4: a[0] = 0;
    5: }
>gcc -c t.c
t.c: In function ‘f’:
t.c:4:2: error: assignment of read-only location ‘*a’

Tip: avoid using snarky comments. When you're wrong it makes you look specially stupid.

> And the funny thing is that most people who write const char* foo really want char const * const foo. You don't want either the pointer or the data pointed at to change. However, almost nobody knows that, so even those who do just use the weaker const char* so people understand the code.

> It's not the bloated obscenity that is C++.

### One good reason... (Score:5, Insightful)
by Darinbob (1142669) on Monday July 02, @04:06PM (#40520627)

Macros aren't really outdated. Maybe 95% of their uses can be replaced with enums or inline functions, but there are also times where textual substitution can do useful things.

Templates as a whole are overused and lead to problems, and in particular tend to not co-exist with object oriented styles. Small simple templates I like, but I see them used to completely replicate a data structure which leads to bloat. And the bloat in C++ is not bloat in features as you sort of imply but bloat in the immense size of the executable. Templates really are just a style of textual substitution, except that unlike C macros this is hidden from the programmers who often don't realize how much extra space can be taken up by them if they're not careful. I don't think there are any compilers yet smart enough to determine when two template instantations only needs one copy at run time, and you end up with standard "libraries" where most of the code is in a header file and recompiled often. To be fair you can use templates that do some nice libraries (ie datastructures store void* and the templates just do the type safety checks for you before casting), except that this is contrary to the STL style. I used to like the rogue wave libraries myself.

You need structs in C++ to be compatible with C. One of C++'s goals is to compile proper C programs and keep compatibility where possible. But if you got rid of the class keyword instead you'd have a revolt. So the typical style almost everyone uses is that struct is used as a plain C struct only, and if you need anything beyond what C can do then you use a class instead. What C++ should have done I think is to enforce that style.

I agree, iostream is awful. Originally it wasn't too bad in some ways and early on it did a good job of adding some extra type safety to IO. But it always felt like a bit of a kludge. It is nice to have a more generic output destination like a stream buffer but it came saddled with the operator overloading and you needed to know implementation details to do a lot of useful stuff.

Diamond inheritance is a side effect of C++ never being able to say no. It should have just said "no multiple inheritance". Once it did have mutliple inheritance it should have not allowed the cross pollenization and stuck to a style where multiple inheritance had only mixins or interfaces. But they didn't want to say "no" and figured that they could use a keyword so that the user could do what they wanted. Which resulted in a lot of confusion.

Actually Ruby is a relatively simple language. A good job of making a textual style of Smalltalk (only with a horrible kludge of blocks). The bloated part may be the Ruby on Rails which is not the same thing at all. Ignoring libraries and looking just at the syntax/semantics of the language then Ruby is much simpler than C++.

#### Re:One good reason... (Score:5, Interesting)
by bluefoxlucid (723572) on Monday July 02, @02:36PM (#40519493) Journal

Compare C++ to Objective-C. You might dislike the syntax of Objective-C some, but it has clear advantages:

It is a strict superset of C: C compiles as Objective-C (C++ doesn't, since structs have a different syntax, among other things)
More importantly, it is runtime-resolved. That means you can expand Objective-C classes without breaking the ABI; in C++ you can't add members to classes, at all. Class members can be in different libraries, and in different header files (a "private" member is one not exposed in the API, but you COULD access it directly by defining it or including the header for it).
The mangling in C++ is a serious pain and makes loading C++ libraries and programs retardedly slow.
Swizzling (you can replace members of classes at runtime--not just inherit, but actually overload class members) makes the language quite a bit more flexible.
Operator overloading and templates are an abomination, and don't exist in Objective-C.
We can all supply better languages for a purpose; Objective-C and C++ have the same purpose (an object oriented general purpose native compiled mid-level programming language), and so this comparison is relevant. Comparing to Java or Python or C#.NET would be irrelevant.

A loose argument can be made that Objective-C is better because of its much better polymorphism features--the main point of an object oriented language. Objective-C does indeed supply much more flexible, more useful polymorphism; C++ class inheritance is pretty rigid because of its rigid ABI. Objective-C's run time resolution enables this, and I would admit that run time resolution of class objects is a bit slower ... if it wasn't optimized by cache (i.e. resolve the first time on demand and build the PLT) AND if C++ class member mangling didn't make actually building the PLT at load time so god damn slow. Two points to Objective-C.

Objective-C doesn't have operator overloading. Operator overloading is often claimed as a negative feature because it makes code hard to read. The effective argument AGAINST operator overloading is is that everyone is used to the 'cout >>' and 'cin

The biggest argument for operator overloading is really that nobody uses it, so we're all familiar with the corner case syntax in the standard library. Think about that: the biggest argument for it is that it never gets used.

Also, Objective C has reference counting with cycle detectors and all. Garbage collection is a limited feature (you can create garbage collected objects intentionally).

It's actually relatively easy to argue that C++ is an abomination. It's not unexpected either: it's an old language, and an OOP shim hacked on top of a well-designed mid-level language. That C is so well designed is surprising; but then it is the legacy of assembly, PASCAL, FORTRAN, and BASIC. COBAL is circa 1959, BASIC circa 1964, C circa 1972, C++ circa 1984. C++ had only Smalltalk to learn from, really, and was trying to be C with Classes.

> Exceptions -- I personally like exceptions, but exceptions in C++ are terrible and not necessary. C++ exceptions have the following problems:

> No clearly defined exception type -- you could potentially catch something that has no descriptive string, no information about the stack, etc.
Double exception faults. This is a subtle problem but one that seems to be easier to trigger in C++ than other languages, and one that could be fixed by changing how exceptions are handled. For those who are not familiar, exceptions that propagate out of a destructor cause abort() to be called if the destructor was called as part of the stack unwinding process for another exception. If I wanted to call abort() when errors occurred, I would not bother with throw statements, I would just call abort().

> Incidentally, the problem here is the order in which things happen. Exceptions should be caught before the stack unwinding process, which guarantees that the handler will execute before another exception is called. This also allows for "restarts" i.e. the ability to resume execution from the point where an exception was thrown, which might make sense (e.g. for exceptions that indicate some non-critical function could not be performed, which should not prevent a critical function from completing).
I have also seen quite a few large C++ projects that simply ban exceptions, because they wind up creating more problems than they solve.

### One good reason... (Score:4, Interesting)
by UnknownSoldier (67820) on Monday July 02, @04:07PM (#40520629)

I used to work with a team that produced a professional C/C++ compiler. We used to joke:

There are two problems with C++
1. it's design
2. it's implementation

As a programming I've come to love the sweet spot 1/2 between C and C++.
C leads to overly terse code
C++ leads to over-engineered solutions

Its too bad the preprocessor is still stuck in the '70s :-( Every year C++ is slowly turning into a clusterfuck LISP implementation by people who don't understand how to write a safe macro meta-language.

### Maybe because it compiles down to the metal... (Score:5, Insightful)
by skids (119237) on Monday July 02, @01:42PM (#40518831) Homepage

...and not some VM? Most of the popular languages these days are all dynamic. And they are very convenient and nice. But if you actually want to know what the machine is actually doing, and want to have a say in such things, C is the way to go.

I mean, unless you want to, you know, use pascal or fortran or something.

### Good habits (Score:5, Insightful)
by Bucky24 (1943328) on Monday July 02, @01:43PM (#40518845)

Personally the thing I like most about C is that it's not "safe". It doesn't take care of a lot of memory management for you and you can easily eat up all the memory or introduce a buffer overload vulnerability if you're not paying attention. It forces programmers to actually look at what they're doing and consider what it will do in the long run, and causes good coding habits to form. I think the majority of people who dismiss C as "too hard" are coming from Java programming. C gives you a lot of power, but, as the well-cliched saying goes, "with great power comes great responsibility".

> of course, programing in C is experience while programming in Java is idle waste.

Problem is the diligence that is required. A C developer is a really good coder when they do their work in an other language. However for large projects, C doesn't make too much sense, because you need to expect your developers to be on their A Game in the course of the project. A developer is porting their proof of concept code into production, right near lunch time, and he is starving, and some of the other guys are waiting on him to finish up, because they are starving too, might mean some code got copied in, and put into the production set, without full though. Because the Proof of Concept code worked, it may pass many layers of Quality Check (and we all know most software development firms have very poor QA teams) Once it leaves and goes to the customer, it could be wide open to a security problem.

Every Developer thinks they are the best developer on earth about 50% of them are actually below average. C is a great teaching tool, I wish most colleges still used it, and didn't switch to .Net and Java. However once you go into production, unless you really need the C performance (and you can code highly optimized C) going with other Languages that are a little more protected is a safer bet.

Hire a C developer... Give him a higher level language, and you will probably get really good code.
Hire a C developer have him program C, you are setting up a time bomb, where once they miss a beat you are screwed.

### simplicity (Score:5, Insightful)
by roman_mir (125474) on Monday July 02, @01:55PM (#40518995) Homepage Journal

C is a very simple language and yet it allows operating memory directly in a way similar to assembler. C is portable (well, it can be compiled for different platforms), I rather enjoyed the language a while back, but since about 98 I use Java for most of big development and I am pretty sure that if I had to do everything in C that I did in Java, it would have taken me much more time.

C is nice in another way - it allows you and in some sense it forces you to understand the machine in a more intimate way, you end up using parts of the machine, registers, memory addresses, you are more physically connected to the hardware. Java is a high level abstraction, but then again, to write so much logic, it is just better to do it at higher level, where you don't have to think about the machine.

C is great tool to control the machine, Java is a great tool to build business applications (I am mostly talking about back end, but sometimes front end too).

So I like C, I used to code in it a lot, but I just to use it nowadays. What's to love about it? Applications written in it can be closely integrated into the specific OS, you can really use the underlying architecture, talk to the CPU but also the GPU (CUDA), if I wanted to use the GPU from a Java application, I'd probably end up compiling some C code and a JNI bridge to it.

C teaches you to think about the machine, I think it gives an important understanding and it's faster to develop in than in Assembler.

### Fortran is better. (Score:4, Informative)
by Rising Ape (1620461) on Monday July 02, @02:31PM (#40519413)

The main problem with Fortran is Fortran programmers. Or, more specifically, those who started off with F77 or earlier and carried on doing things the same way. For numerical stuff, I prefer F90 or later to C - far fewer ways to shoot yourself in the foot with memory management.

