# Ruby changes from 1.8 to 1.9

## How proc and lambda behavior differs significantly from 1.8

### new "stabby lambda" syntax:
	# Ruby 1.8
	lambda{|x,y| x + y}
	# Ruby 1.9
	->(x,y){ x + y}

## How to wrestle with character encodings like UTF-8 (and issues to be aware of when upgrading old apps)
## The new and differing ways to check range membership
## How old Ruby 1.9 is and where it has descended from
## New tricks and techniques opened up by the awesome new Oniguruma-based regular expression engine
## The new MiniTest::Unit and MiniTest::Spec libraries
## Quickly calling system library functions with Fiddle
## Code coverage utilities right in the stdlib
## Extensions to splat (*) behavior in 1.9
## New hash syntax and key changes to hash methods
## The 3 different encoding types in 1.9 and why each is important
## What fibers are, how they compare to threads, and how threads have changed
## Why Proc#=== makes sense as a way to call procs.. sometimes
## 1.9.3 specific updates (stuff that's not even in 1.9.2!)
## How to tweak the garbage collector in 1.9.3

- The History of Ruby 1.9
- Alternative 1.9 Implementations
- Key Changes (Overview)
- Getting Ruby 1.9
- Strings
- Character Encoding
- Hashes
- Arrays
- Procs and Lambdas
- Blocks
- Enumerators and Enumerable
- Regular Expressions
- Threads
- Fibers
- Time
- Standard Library (New and Gone)
- New Syntax and Miscellaneous Elements
- Garbage Collection
- Ruby 1.9.3 Specifics