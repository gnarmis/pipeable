# Pipeable

A small (< 34 sloc) library that allows you to 'pipeline,' or 'thread' a value
through a number of callables.

```
Pipeable(3) | :add_one | :square | ->(x) { x-3 } | :puts
# prints '13'
```

## Installation

[![Gem Version](https://badge.fury.io/rb/pipeable.svg)](https://badge.fury.io/rb/pipeable)

Run `gem install pipeable` or add `gem "pipeable"` to your Gemfile.

Then, you can `require` it and `include` it as needed.

```
> require 'pipeable'
> include Pipeable
> Pipeable(1) | ->(x) { x + 1 } | :puts
# prints "2"
````

## Usage


Sometimes, you have to compose a series of discrete actions into one composed
function. In something as basic as a bash/zsh function, you can compose
discrete steps (like a particular `grep` or `sed` invocation, or any
binary/script at all) using UNIX pipes. But in Ruby, this kind of operation is
a few steps removed; there's no vocabulary for building a 'pipeline.' Also, in
languages like Racket and Clojure, you have the `->` macro (among others) to
make just such a pipeline.

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

## Develop

As you can see in `LICENSE.txt`, we have an MIT license.

Pull requests welcome, but please help keep this a super tiny library!

## Test

```
bundle exec rspec spec
```



