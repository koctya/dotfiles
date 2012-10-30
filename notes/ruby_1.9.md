# Ruby 1.9 Walkthrough by Peter Cooper
## Strings
- Parse lines in a String object with #each_line or #lines, instead of #each
- String#ord returns the UTF-8 index
- "x".ord is the new way of doing ?x
- ?a == "a" (and no more "97")
- "A".ord == 65, "ABC".ord == 65
- String#codepoints to get an enumerator of each codepoint (UTF-8 index)
`> "Aab".codepoints.each {|x| print "#{x} "}
65 97 98
 => "Aab"`
- String#clear clears to an empty string in place
- String are now in terms of characters (UTF-8 by default) rather than bytes
- String#length now returns length in chars, not bytes
- String#[] now returns entire characters, not individual bytes
- String#encoding returns the relevant Encoding object for the string
- Encoding.list.length = 95 encodings
- tip #1: explicitly declare encodings on any IO objects you're opening
- tip #2: add the magic comment on top of all source files (# encoding: utf-8)

#### Strings to arrays
Ruby 1.8 supported .to_a on a string to convert to an array,
The equivalent in ruby1.9 is:

    lines = string.lines.to_a
    chars = string.chars.to_a # to get array of chars
    bytes = string.bytes.to_a # to get array of bytes

The issue with this solution, is that the ruby1.9 solution is not compatible with ruby1.8.


## Hashes
- new hash syntax: {name: "value"}
- a Hash instance is now an ordered Hash
- Hash#select now returns a Hash instead of an Array
- Hash#select! is an in-place version of Hash#select
- new methods: Hash#default_proc and Hash#default_proc=
- Hash#flatten turns the Hash into an interleaved Array
- new methods: Hash#assoc and Hash#rassoc
- Hash#keep_if amends a Hash in place


## Arrays
- Array#to_s no longer joins, but returns an #inspect-style representation
- Array#choice goes, Array#sample arrives (and takes an optional quantity arg)
- Array#shuffle is still around
- Array#uniq, Array#uniq! and Array#product now take blocks
- not new but useful: Array#inject can take a symbol representing a method to run each time, e.g. inject:)+)


## Procs and Lambdas
- proc {} now creates a Proc, not a lambda like in 1.8
- check if Proc objects are lambdas with #lambda?
- recap: lambdas enforce arity (argument count), regular procs do not
- "stabby" lambda syntax: ->x{x * 2 } or ->(x,y,z){x * y * z}
- Proc#[] still works for calling a proc/lambda (as does #call)
- recap: Ruby 1.8 lambdas didn't enforce arity when no params were listed, and it's been fixed in 1.9
- recap: Ruby 1.8 lambdas with 1 param only gave a warning when called with many args, and it's now fixed in 1.9
- .() calls the #call method on proc/lambda, but also on other types of object
`> a = {}; def a.call; 20; end; a.()
 => 20`
- Proc#=== will call the proc/lambda (useful in case statements in a "when" block)
` > ->x{ x.odd? } === 3
  => true`
- Proc#curry takes a multiple arg proc and turns it into a chain of single arg procs
`>  > ->(a,b,c){ a + b + c }.curry[1][2][3]
  => 6`
- Proc#source_location returns [filename, line_number]



## Blocks
- Block parameters are now always local to their block
- non block parameters are not seen in a different scope when in a block
- in a block parameter list, you can list block-local variables, after a semi-colon
- you can now pass a block when calling a proc:
`> proc {|&b| b.call("hello") }.call {|c| puts c}
hello
 => nil`
- Enumerator was back-ported to Ruby 1.8.7
- Enumerator#with_index accepts an optional starting index
- Enumerator#with_object accepts an object, e.g. `[1.2.3].each.with_object({}) {|i,a| a[i] = i}`
- Enumerator#peek checks out next item w/o advancing pointer


## Regular Expressions
- "abc123" =~ /[[:digit]]/
- "a++" returns 1 or more "a" but 'possessive' (no backtracking allowed by parser)
- (?= … ) is a zero-width positive lookahead
- (?<= … ) is a zero-width positive lookbehind
- (?! … ) are zero-width negative lookahead
- (?<! … ) is a zero-width negative lookbehind
- (?<name>pattern) is a "named match" or "named group" called "name"
- MatchData#[] lets you use matched names using symbols, e.g. md[:name]
- (?<name>…){0} doesn't match immediately but stores regex for later
- \g<name> makes use of the named match "name" at the current point
- Unicode properties: \p{property name} (\P{property name} for opposite)


## Threads
- Threads are real system-level threads
- GIL (Global Interpreter Lock) still applies
- enforce that only one thread can run at any one time in the Ruby VM
- IO is async thread (another thread can run while IO is occurring)
- C extensions have the option to "release" the GIL
- Thread#set_trace_func and Thread#add_trace_func


## Fibers
- lighter way of doing concurrency
- fiber is a subroutine with multiple entry points
- Ruby VM uses fibers to implement enumerators internally
- Fiber#new to create a new Fiber object
- Fiber#resume will resume execution of the fiber
- Fiber.yield yields control (and sometimes data) back to the caller


## Time
- Time#parse was using the American format; it'snow using the British format, e.g. `Time.parse("30/12/2001")`
- We now have: Time#monday?,  Time#tuesday? , etc
- Time.now.usec gives the microseconds
- (Time.now == Time.now) will return false
- Time.now.subsec returns a fraction of 1 000 000 usec


##New in the Standard Library
- JSON support: #to_json and JSON.load(js)
- j and jj
- Syck and Psych
- MiniTest runs test methods in a random order to test their fragility
- Need to add "minitest/autorun" to make MiniTest tests run automatically
- assert_not_[something] becomes refute_[something]
- must_equal() becomes wont_equal() in the negative
- FasterCSV becomes CSV
- Foreign Function Interface library
- Fiddle library : a nice abstraction to make using FFI easier
- rake is now included
- the Tk Windowing Toolkit is now included
- Ripper library to see how Ruby 1.9 parses Ruby to an AST
- Prime is a prime library
- Coverage library gives basic coverage stats for your code (must load file)
`Coverage.start
require_relative 'file'
puts Coverage.result`



## Gone from the Standard Library
- date2 (was a derivative of date)
- ftools library (FileUtils does what ftools used to do)
- The Generator class (we've got Enumerator now)
- getopts (we should use optparse)
- jcode library (used to handle Japanese EUC/SJIS strings)
- mailread library (use TMail instead)
- parsedate
- ping (used for TCP echoing)
- readbytes library
- RubyUnit (old way of doing unit testing)



## New Syntax and misc elements
- RUBY_VERSION
- RUBY_ENGINE
`>  def my_method; p __callee__; end; my_method
:my_method
 => :my_method`
- File::Stat#world_readable? and #world_writable?
- Many File methods can use objects that implements a to_path method
`a = []; def a.to_path; '/etc/passwd'; end; File.open(a)`
- Object#id was deprecated and it's now removed. Use #object_id instead
- Object#tap is a "passthrough" method for inspecting things
- Negative operators can now be defined/overridden (i.e. !, !=, !~)
- Splat operator enhanced (can be applied to non-last parameters, or have multiple splats on the right-hand side)
- Optional arguments can now appear before mandatory ones
`('a'..'z').include?('car')
 => false
('a'..'z').member?('car')
 => false
('a'..'z').cover?('car')
 => false`
- Kernel#methods (and friends) now returns an array of symbols, not strings anymore
- Block args can no longer be instance variables, e.g. {|@x|}
- You can now spread methods chains across multiple lines
- You can also spread a ternary operation across multiple lines
- Object.superclass = BasicObject
- Method#source_location is much like Proc#source_location
- useful to know if a method has been monkey patched
- Symbol supports #=~, #!~ and #match (but does not return a MatchData)
- Symbol#to_i is no more
- Symbols get #< , #> , #<= , #>= for comparisons
- No more when: in case blocks (use ; or newlines instead)
- No more colon on "if" (use ;, then, or newlines instead)
- Module#const_defined? now looks for the parameter in the ancestors too (use false to prevent that)
- Same applies for const_get and method_defined?
- Class#class_variable_set and #class_variable_get are now public
- Object#define_singleton_method
- public_send and public_method respect private definitions
- Class X; end; X.singleton_class == (class << X; self; end)
base64 is still there
- Process#daemon daemonizes the current process
- Process#spawn
- Complex(3,4) == (3 + 4.i)
- Binding#eval(code_string) has been added, but eval("name, binding) still works
- Float::INFINITY
`sprintf("%A", 1.234) # hex floating point format
 => "0X1.3BE76C8B43958P+0"`
- no more retry in loops
- new method: respond_to_missing?


## Garbage Collection

- GC.count
- GC::Profiler
- ObjectSpace module
- garbage collection tweaking options (e.g. RUBY_GC_MALLOC_LIMIT)


## Ruby 1.9.3 Specifics
- "load.c" patch to speed up requiring/loading files
- Garbage collection parameters now can be set in the environment
- Pathname and Date libraries re-implemented in C for more performance
- Random.new.rand(1..10)
- Random.rand(1..10)
- rand(1..10)
- Time.now.strftime("%b %d", %Y %z %:z %::z)
- String#prepend prepends a string in place
- String#byteslice(range) or String#byteslice(quantity, index)
- io/console
- joint GPL2-Ruby to a joint 2-clause BSD and Ruby license
- OpenSSL has new maintainers
- New encodings: cp950, cp951, UTF-16, UTF-32
` > File::NULL
  => "/dev/null"`
- matrix library being improved
- net/http now supports "100 Continue" status
