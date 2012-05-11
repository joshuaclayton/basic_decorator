# BasicDecorator

Decoration in Ruby should be easy. With `BasicDecorator`, it is.

`BasicDecorator` was spawned by my [Gist](https://gist.github.com/1523849) in
response to [this post on the thoughtbot
blog](http://robots.thoughtbot.com/post/14825364877/evaluating-alternative-decorator-implementations-in).

## Installation

Add this line to your application's Gemfile:

    gem 'basic_decorator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install basic_decorator

## Usage

Decorators are a wonderful design pattern allowing a developer to modify,
extend, or otherwise change the behavior of an object while maintaining its
interface. Remember ActiveSupport's `alias_method_chain`? That was essentially
an inline (bastardized) decoration that mutated the object. If you want to
read about the Decorator pattern, I suggest you check out:

* [C&C Wiki](http://c2.com/cgi/wiki?DecoratorPattern)
* [Wikipedia](http://en.wikipedia.org/wiki/Decorator_pattern)

Knowing about decorators, where does `BasicDecorator` fall? How do you use it?

Your decorators inherit from `BasicDecorator::Decorator` and you'll have
access to the instance variable `@component`, the object passed in to the
decorator's constructor.

Let's start off with the common 'Coffee', 'Cream', and 'Sugar' example. Here's
our first object, `Coffee`.

```ruby
class Coffee
  def cost
    Money.new(250, 'USD')
  end

  def origin
    'Columbia'
  end

  def additional_ingredients
    []
  end
end
```

Fairly straightforward. Let's write up decorators for `Cream` and `Sugar`.

```ruby
class Cream < BasicDecorator::Decorator
  def cost
    @component.cost + ::Money.new(75, 'USD')
  end

  def additional_ingredients
    @component.additional_ingredients + ['Cream']
  end
end

class Sugar < BasicDecorator::Decorator
  def cost
    @component.cost + ::Money.new(25, 'USD')
  end

  def additional_ingredients
    @component.additional_ingredients + ['Sugar']
  end
end
```

If a method isn't defined on the decorator, it gets delegated to the
`@component` (via `method_missing`, meaning it'll keep your decorators nice
and thin; only define the methods of whom you want to change the behavior.

`Sugar` and `Cream` may decorate `Coffee` any number of times.

```ruby
coffee = Coffee.new
# #<Coffee:0x007fb78a8c5ae8>
tasty_coffee = Sugar.new(Cream.new(coffee))
# #<Coffee:0x007fb78a8c5ae8>

coffee.cost
# #<Money cents:250 currency:USD>
tasty_coffee.cost
# #<Money cents:350 currency:USD>

coffee.additional_ingredients
# []
tasty_coffee.additional_ingredients
# ["Cream", "Sugar"]

tasty_coffee.is_a? Coffee
# true
```

You may want to be careful of decorating objects like arrays. Decoration
typically won't mutate the component you're decorating; again, just something
to be aware of.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
