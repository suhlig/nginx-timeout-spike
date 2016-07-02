# nginx + puma = scale

A minimal [Sinatra](sinatrarb.com) application fronted by nginx. Both communicate via Unix Domain Sockets, which should be more efficient than HTTP.

## Install Dependencies (once)

```
# Install OS packages like nginx
$ brew bundle

# Install rubygems
$ bundle install

# Install foreman (not part of the Gemfile [on purpose](https://github.com/ddollar/foreman#installation))
$ gem install foreman
```

## Start

```
$ foreman start
```

In order to determine the port instead of letting foreman auto-select it, pass it as parameter:

```
$ foreman start -p 7890
```

## Test

```
$ curl -vvv localhost:5100/
…
# stream content for five seconds
$ curl -vvv localhost:5000/stream?t=5
…
# wait five seconds before returning the result
$ curl -vvv localhost:5000/slow?t=5
```

## Reload Config

```
nginx -c $(realpath nginx.conf) -s reload
```

# Notes

* nginx works with absolute file names only ([except relative to the --prefix passed at compile time](http://nginx.org/en/docs/configure.html)), thus we need to generate the nginx.conf at start.
