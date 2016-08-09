# Pipeable

A small (< 34 sloc) library that allows you to 'pipeline,' or 'thread' a value
through a number of callables.

```
Pipeline(3) | :add_one | :square | ->(x) { x-3 } | :puts
# prints '13'
```

Sometimes, you have to compose a series of discrete steps into one composed
function. In something as basic as a bash/zsh function, you can compose
discrete steps (like a particular `grep` or `sed` invocation, or any
binary/script at all) using UNIX pipes. But in Ruby, it's a few steps removed;
there's no vocabulary for building a 'pipeline' of sorts. Also, in languages
like Racket and Clojure, you have the `->` macro (among others) to make just
such a pipeline.

Well, let's extend Ruby's vocabulary a bit!

```
> require 'lib/pipeable'
> include Pipeable
> Pipeable(0) | ->(x) { x + 1 } | :puts
# prints out "1"
```

Another, slightly more complex example:

```
class TestClass
  include Pipeable
  
  def add_one(x)
    x + 1
  end

  def square(x)
    x ** 2
  end
  
  def pipe(y)
    result = Pipeable(y) | :add_one | :square
    result.value
  end
end

# `TestClass.new.pipe(3)` will result in `16`
```



