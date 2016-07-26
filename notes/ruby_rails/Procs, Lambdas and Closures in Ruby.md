# [An Introduction to Procs, Lambdas and Closures in Ruby](https://www.youtube.com/watch?v=VBC-G6hahWA)

### Blocks

    def run_block
      yield if block_given?
    end
    
    run_block do
      puts "Hello world"
    end

###Procs
    class Array
      def random_each(&b)
        p b
        shuffle.each do |el|
           b.call el
    #      yield el
        end
      end
    end
    
    [1, 2, 3, 4].random_each do |el|
      puts el
    end

running multiple procs

    def run_two_procs(a, b)
      a.call
      b.call
    end
    
    proc1 = Proc.new do
      puts "This is proc1"
    end
    
    proc2 = Proc.new do
      puts "This is proc2"
    end
    
    run_two_procs  proc1 proc2

4 ways to call a proc

    my_proc = Proc.new do |a|
      puts "This is my proc and #{a} was passed to me"
    end
    
    my_proc.call(10)
    
    my_proc.(20)    # synonym for .call()
    
    my_proc[30]
    
    my_proc === 40    # syntax for case statements

procs in case statement

    several = Proc.new {|num| num > 3 && num < 8 }
    many = Proc.new {|num| num > 5 && num < 8 }
    few = Proc.new {|num| num == 3 }
    couple = Proc.new {|num| num == 2}
    none = Proc.new {|num| num == 0}
    
    0.upto(10) do |num|
      print "#{num} item is "
      
      case num
        when several    # several === num
          puts "several"
        when many
          puts "many"
        when few
          puts "a few"
        when couple
          puts "a couple"
        when none
          puts "none at all"
        else
        puts "awesome"
      end
    end

## Lambdas
like proc objects with small diffs.

lambdas enforce arity (same num parameters, acts more like a method)

    hello = lambda do |a, b, c
      puts "This is a lamba"
    end

    hello.call

## Closures

maintains references to local vars relative to code

    def  run_proc(p)
      p.call
    end
    
    name = "Fred"
    print_a_name = proc { puts name }
    run_proc print_a_name

more

    def multiple_generator(m)
      lambda do |n|
        n * m
      end
    end
    
    doubler = multiple_generator 2
    tripler = multiple_generator 3
    
    puts doubler[5]
    # => 10
    puts tripler[10]
    # => 30

