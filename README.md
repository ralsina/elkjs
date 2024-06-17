# elkjs

This is a [Crystal](https://crystal-lang.org) wrapper for the
[Elk javascript engine](https://github.com/cesanta/elk)

Elk is a *tiny* javascript implementation, and the goal of this wrapper is
to make it very easy to use and extend from Crystal.

**Important:** This is not a replacement for duktape or any other JS engine,
it's *very* limited, it has no standard library at all, it doesn't even support
arrays, objects, functions or integers!

It's just a simple way to run some JS code in a Crystal
runtime that can call back to Crystal code.

On the other hand, if you want to provide some limited scriptability to
your Crystal app or library it may be just what you need, and it sure will
be easy to use and small.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     elkjs:
       github: ralsina/elkjs
   ```

2. Run `shards install`

## Usage

The whole API is wrapped in the `Elk` module, and a more comfortable
high level API is provided in the `Js` module.

Here is an example:

```crystal
require "elkjs"

# Create a new engine
js = Js::Engine.new

# Define a global function called "print" that will print to stdout
js.set_global("print", Js.func(->(args : Js::Args) {
  args.each do |arg|
    puts arg
  end
  Js::UNDEF # Return undefined
}))

# A classic
js.eval("print('Hello, World!');")

# You can loop
js.eval("
    for (let i=0; i<5; i++) {
    print(i);
}")

# Eval returns the last value
puts js.eval("1+1") # => 2
```

For documentation in the underlying library, see [their site](https://github.com/cesanta/elk/tree/master) and you can always read the [source for ElkJS](https://github.com/ralsina/elkjs) since it's pretty tiny.

## Development

* To build the example run `make`
* A `src/elk.o` needs to be generated for this to link.
  I think shard.yml should do that. If not, run `gcc -DJS_DUMP -c lib/elkjs/src/elk.c -o lib/elkjs/src/elk.o`

## Contributing

1. Fork it (<https://github.com/ralsina/elkjs/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

* [Roberto Alsina](https://github.com/ralsina) - creator and maintainer
