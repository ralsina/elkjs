# elkjs

This is a [Crystal](https://crystal-lang.org) wrapper for the 
[Elk javascript engine](https://github.com/cesanta/elk)

Elk is a *tiny* javascript implementation, and the goal of this wrapper is
to make it very easy to use and extend from Crystal.

Details to be written later.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     elkjs:
       github: ralsina/elkjs
   ```

Run `gcc -c lib/elkjs/src/elk.c -o lib/elkjs/src/elk.o`

2. Run `shards install`

## Usage

```crystal
require "elkjs"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/ralsina/elkjs/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Roberto Alsina](https://github.com/ralsina) - creator and maintainer
