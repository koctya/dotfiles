# 24 Ruby Tricks
## Random number from a range
on Ruby 1.9.3
`rand(10..20)`

## AwesomePrint
`gem install "awesome_print"`
require 'ap'

## concat

`puts "abc" "def"`

## fiddle
part of stdlib in ruby

    require 'fiddle'
    
    libc = DL.dlopen "libc.dylib"
    
    f = Fiddle::Function.new(libc['strlen'],
        [Fiddle::TYPE_VOIDP],
        Fiddle::TYPE_INT)
    
    p f.call("abcde").to_i
 
ffi

    require 'ffi'
    
    module Foo
        extend FFI::Library
    
        ffi_lib 'c'
    
        attach_function :strlen, [:string], :int
    end
    
    p Foo.strlen("abcde")


#### Example crypt

    require 'fiddle'
    
    module CCrypt
      @libc = DL.dlopen 'libc.dylib'
    
      def self.crypt3(str, salt)
        Fiddle::Function.new(@libc['crypt', [Fiddle::TYPE_VOIDP, Fiddle::TYPE_V
      end
    end
    
    p CCrypt.crypt3('a', 'b') if __FILE__ == $0

## Simple test for substring

    > x = "this is a test"
    > x["test"]
     => "test"
    > x["yyyy"]
     => nil


## Module include order

    module A
      def self.included(base); puts self.name; end
    end
    
    module B
      def self.included(base); puts self.name; end
    end
    
    module C
      def self.included(base); puts self.name; end
    end
    
    class D
      include A, B, C
    end

## String Interpolation shortcut

if including a var with @ symbol, don't need curly braces.

    > @mystr = "this is a test"
    > "fdsafdsa #{@mystr}"
     => "fdsafdsa this is a test"
    > "fdsafdsa #@mystr abcde"
     => "fdsafdsa this is a test abcde"

## Ruby syntax checking at the command line

    > ruby -c awesome.rb
    Syntax OK

## ruby syntax with Ripper

    require 'ripper'
    require 'ap'
    
    ap Ripper.sexp "puts {}.class"

## next as a "return" for procs and blocks

    10.upto(20) do |i|
      next if i.even?
      puts i
    end

    a = [1, 2, 3, 4].map do |bar|
      next 10 if rand(2) == 0
      bar * 2
    end
    
    p a

[An Introduction to Procs, Lambdas and Closures in Ruby](https://www.youtube.com/watch?v=VBC-G6hahWA)

## zipping arrays together

    names = %w{fred jess john}
    ages = [38, 47, 91]
    
    p names.zip(ages)
    # => [["fred", 38], ["jess", 47], ["john", 91]]
    
    p Hash[names.zip(ages)]
    # => {"fred" => 38, "jess" => 47, "john" => 91}

## exploding ranges into arrays

    > [*10..20]
    # => [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    > c = 10
    > [*c]
    # => [10]
    > c = [1,2,3,4]
    > [*c]
    # => [1, 2, 3, 4]
    > Array(c)
    # => [1, 2, 3, 4]
    > Array(10..20)
    # => [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

## json output

    require 'json'
    > h
    
    > j
    
    > jj

## using `__method__`

    class X
      def self.make_stuff(*meths)
        meths.each do |meth|
          define_method(meth) do
            __method__
          end
        end
      end
    
      make_stuff :a, :b, :c
    end
    
    x = X.new
    p x.a
    p x.b
    p x.c

## multiline method chaining

## `_` in irb

refers to last returned value

## Proc#source_location

useful for debugging, or for tools;

    a = ->{ }
    b = ->{ }
    
    p a.source_loation
    p b.source_loation
    
    # require 'ap'
    #p method(:ap).source_location
    
    #require 'active_support/core_ext/string/inflections'
    #p "WonderBar".method(:tabelize).source_location

## Storing data in the source code

    puts "Hello world!"
    
    # DATA.rewind
    puts DATA.read
    
    __END__
    
    puts "do we ever get here?"

## regular expresion tricks

    > str = "Fred Flintstone: Superhero"
    
    > str[/\w+/]
     => "Fred"
    
    > str[/(\w+) (\w+)/]
     => "Fred Flintstone"
    
    > str[/(\w+) (\w+)/, 1]
     => "Fred"
    
    > str[/(\w+) (\w+)/, 2]
     => "Flintstone"
    
    > str[/(?<a>\w+) (?<b>\w+)/]
    
    > $~[:a]
     => "Fred"
    > $~[:b]
     => "Flintstone"
    
    > /(?<a>\w+) (?<b>\w+)/ =~ str
    
    > a
     => "Fred"
    > b
     => "Flintstone"

