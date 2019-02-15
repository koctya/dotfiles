# Go pros & cons

# Elm 
- Functional Programming Language
- Compiles to Javascript
- Focus on Simplicity
  -- No Component System

"There are certain Best Practices that deserve to be challanged"
## To Maximize Maintainablity...
(note this does not belong here, I just added it while watching a screencast about ELM, FP)

Best Practices:

instead of --- prefer
mutable objects --> immutable data
stateful components --> stateless components
imperative, side efects --> declarative, pure functions

# Quotes

> Go is a language for programmers who want to get things done.

Go is about pure pragmatism.

> Go’s purpose is therefore not to do research into programming language design; it is to improve the working environment for its designers and their coworkers. Go is more about software engineering than programming language research. Or to rephrase, it is about language design in the service of software engineering.
  - Rob Pike 

> Syntax is the user interface of a programming language. Although it has limited effect on the semantics of the language, which is arguably the more important component, syntax determines the readability and hence clarity of the language. … Go was therefore designed with clarity and tooling in mind, and has a clean syntax.
  - Rob Pike 

> Software engineering guided the design of Go. More than most general-purpose programming languages, Go was designed to address a set of software engineering issues that we had been exposed to in the construction of large server software. Offhand, that might make Go sound rather dull and industrial, but in fact the focus on clarity, simplicity and composability throughout the design instead resulted in a productive, fun language that many programmers find expressive and powerful.
  - Rob Pike 

> Go is a language that chooses to be simple, and it does so by choosing to not include many features that other programming languages have accustomed their users to believing are essential.
So the subtext of this thesis would be: what makes Go successful is what has been left out of the language, just as much as what has been included.
Or as Rob Pike puts it, “less is exponentially more.”
  - Dave Cheney

# Cons - [Why Go Is Not Good](http://yager.io/programming/go.html)

- no Generic Programming
- Go does not support operator overloading or keyword extensibility.
- Go's Solution: Nil (and multiple return)
- Type Inference - Go's solution: :=
- Immutability - Go does not support immutability declarations.
- C-style Valueless Statements, it doesn't have compound expressions or pattern matching
