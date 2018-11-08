# Сord

Crystal shard for Tarantool with auto reconnect and connections pool based on original shard for Redis by [kostya/redisoid](https://github.com/kostya/redisoid) but slightly adapted. Also shard uses [ysbaddaden/pool](https://github.com/ysbaddaden/pool) and [vladfaust/tarantool.cr](https://github.com/vladfaust/tarantool.cr) of course.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cord:
    github: creadone/cord
```

## Usage

```crystal
require "cord"

tarantool = Сord::Connection.new(host: "localhost", port: 6379, pool: 50)
tarantool.ping #=> 00:00:00.000159976
```

## Tests

TODO
