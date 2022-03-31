# JavaScript

## JavaScript: Function Invocation Patterns
### JavaScript Functions

JavaScript has been described as a Functional Oriented Language (this as opposed to Object Oriented Language). The reason is because functions in JavaScript do more than just separate logic into execution units, functions are first class citizens that also provide scope and the ability to create objects. Having such a heavy reliance upon functions is both a blessing and a curse: It's a blessing because it makes the language light weight and fast (the main goal of its original development), but it is a curse because you can very easily shoot yourself in the foot if you don't know what you are doing.

One concern with JavaScript functions is how different invocation patterns can produce vastly different results. This post explains the four patterns, how to use them and what to watch out for. The four invocation patterns are:

1. Method Invocation
2. Function Invocation
3. Constructor Invocation
4. Apply And Call Invocation

### Function Execution

JavaScript (like all languages these days) has the ability to modularise logic in functions which can be invoked at any point within the execution. Invoking a function suspends execution of the current function, passing controls and parameters to the invoked function. In addition, a parameter called this is also passed to the function. The invocation operator is a pair of round brackets (), that can contain zero or more expressions separated by a comma.

Unfortunately, there is more than one pattern that can be used to invoke functions. These patterns are not nice-to-know: They are absolutely essential to know. This is because invoking a function with a different pattern can produce a vastly different result. I believe that this is a language design error in JavaScript, and had the language been designed with more thought (and less haste), this would not have been such a big issue.

### The Four Invocation Patterns

Even though there are is only one invocation operator (), there are four invocation patterns. Each pattern differs in how the this parameter is initialised.

### Method Invocation

When a function is part of an object, it is called a method. Method invocation is the pattern of invoking a function that is part of an object. For example:

    var obj = {
        value: 0,
        increment: function() {
            this.value+=1;
        }
    };

    obj.increment(); //Method invocation

Method invocation is identified when a function is preceded by object., where `object` is the name of some object. JavaScript will set the this parameter to the current object when method invocation used. In the example above, this would be set to obj. JavaScript binds `this` at execution (also known as late binding).

### Function Invocation

Function invocation is performed by invoking a function using ():

    add(2,3); //5

When using the function invocation pattern, `this` is set to the global object. This was a mistake in the JavaScript language, always binding `this` to the global object can destroy its current context. It is noticable when using an inner function within a method function. An example should explain things better:


    var value = 500; //Global variable
    var obj = {
        value: 0,
        increment: function() {
            this.value++;

            var innerFunction = function() {
                alert(this.value);
            }

            innerFunction(); //Function invocation pattern
        }
    }
    obj.increment(); //Method invocation pattern

What do you think will be printed to screen? For those that answered `1`, you are wrong (but don't be too hard on yourselves, this is because JavaScript does not do things very well). The real answer is `500`. Note that `innerFunction` is called using the function invocation pattern, therefore this is set to the global object. The result is that `innerFunction` (again, it is important to note that it is invoked with function pattern) will not have `this` set to current object. Instead, it is set to the global object, where `value` is defined as 500. I stress that this is bad language design; the increment function was invoked with the method invocation pattern, and so it is natural to assume the this should always point to the current function when used inside it.

There is an easy way to get round this problem, but it is in my opinion a hack. One gets around this problem by assigning a variable (by convention, it is named `that`) to `this` inside the function:

    var value = 500; //Global variable
    var obj = {
        value: 0,
        increment: function() {
            var that = this;
            that.value++;

            var innerFunction = function() {
                alert(that.value);
            }

            innerFunction(); //Function invocation pattern
        }
    }
    obj.increment();

If this could be bound to the current object whose scope it is called in, function and method invocations would be identical.

### Constructor Invocation

_Warning_: This is another JavaScript peculiarity! JavaScript is not a classical object oriented language. Instead, it is a prototypical object oriented language, but the creators of JavaScript felt that people with classical object orientation experience (the vast majority) may be unhappy with a purely prototype aproach. This resulted in JavaScript being unsure of its prototypical nature and the worst thing happened: It mixed classical object orientation syntax with its prototypical nature. The result: A mess!

In classial object orientation, an object is an instantiation of a class. In C++ and Java, this instantiation is performed by using the `new` operator. This seems to be the inspiration behind the constructor invocation pattern...

The constructor invocation pattern involves putting the new operator just before the function is invoked.

For example:

    var Cheese = function(type) {
        cheeseType = type;
        return cheeseType;
    }

    cheddar = new Cheese("cheddar"); //new object returned, not the type.

Even though `Cheese` is a function object (and intuitively, one thinks of functions as running modularised pieces of code), we have created a new object by invoking the function with `new` in front of it. The `this` parameter will be set to the newly created object and the return operator of the function will have its behaviour altered. Regarding the behaviour of the `return` operator in constructor invocation, there are two cases:

1. If the function returns a simple type (number, string, boolean, null or undefined), the return will be ignored and instead this will be returned (which is set to the new object).
2. If the function returns an instance of Object (anything other than a simple type), then that object will be returned instead of returning this. I must point out that this pattern is not used that often, but it does have some uses with closures.

For example:

    var obj = {
        data : "Hello World"
    }

    var Func1 = function() {
        return obj;
    }

    var Func2 = function() {
        return "I am a simple type";
    }

    var f1 = new Func1(); //f1 is set to obj
    var f2 = new Func2(); //f2 is set to a new object

We might ignore this, and just use [object literals](http://doctrina.org/JavaScript-Objects-Prototypes.html#cofl) to make objects, except that the makers of JavaScript have enabled a key feature of their language by using this pattern: Object creation with an arbitrary prototype link (see [previous post](http://doctrina.org/JavaScript-Objects-Prototypes.html) for more details). This pattern is unintuitive and also [potentially problematic](http://doctrina.org/JavaScript-Objects-Prototypes.html#pcip). There is a [remedy](http://doctrina.org/JavaScript-Objects-Prototypes.html#remedy) which was championed by Douglas Crockford: Augment `Object` with a create method that accomplishes what the constructor invocation pattern tries to do. I am happy to note that as of JavaScript 1.8.5, `Object.create` is a reality and can be used. Due to legacy, the constructor invocation is still used often, and for backward compatability, will crop up quite frequently.

### Apply And Call Invocation

The apply pattern is not as badly thought out as the preceding patterns. The `apply` method allows manual invocation of a function with a means to pass the function an array of parameters and explicitly set the `this` parameter. Because functions are first class citizens, they are also objects and hence can have methods (functions) run on it. In fact, every function is linked to `Function.prototype` (see [here](http://doctrina.org/JavaScript-Objects-Prototypes.html#cfo) for more details), and so methods can very easily be augmented to any function. The apply method is just an augmentation to every function as - I presume - it is defined on `Function.prototype`.

Apply takes two parameters: the first parameter is an object to bind the `this` parameter to, the second is an array which is mapped to the parameters:

    var add = function(num1, num2) {
            return num1+num2;
    }

    array = [3,4];
    add.apply(null,array); //7

In the example above, `this` is bound to null (the function is not an object, so it is not needed) and array is bound to `num1` and `num2`. More interesting things can be done with the first parameter:

    var obj = {
        data:'Hello World'
    }

    var displayData = function() {
        alert(this.data);
    }

    displayData(); //undefined
    displayData.apply(obj); //Hello World

The example above uses `apply` to bind `this` to obj. This results in being able to produce a value for this.data. Being able to expicitly assign a value to `this` is where the real value of apply comes about. Without this feature, we might as well use `()` to invoke functions.

JavaScript also has another invoker called `call`, that is identical to `apply` accept that instead of taking an array of parameters, it takes an argument list. If JavaScript would implement function overriding, I think that `call` would be an overridden variant of `apply`. Therefore one talks about `apply` and `call` in the same vein.

## Conclusion

For better or worse, JavaScript is about to take over the world. It is therefore very important that the peculiarities of the langauge be know and avoided. Learning how the four function invocation methods differ and how to avoid their pitfalls is fundamental to anyone who wants to use JavaScript. I hope this post has helped people when it comes to invoking functions.
