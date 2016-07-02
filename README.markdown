# nginx + puma = scale

A minimal [Sinatra](sinatrarb.com) application fronted by nginx. Both communicate via Unix Domain Sockets, which should be more efficient than HTTP.

## Install Dependencies (once)

```
# Install OS packages like nginx
$ brew bundle

# Install rubygems
$ bundle install
```

Also install `foreman`, but not as part of the Gemfile ([on purpose](https://github.com/ddollar/foreman#installation)):

```
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
$ curl -vvv localhost:5000/
…
# stream content for five seconds
$ curl -vvv localhost:5000/stream?t=5
…
# wait five seconds before returning the result
$ curl -vvv localhost:5000/slow?t=5
```

## Stress Test

```
# start stress test
wrk --threads 12 --connections 60 --duration 60s --timeout 10 http://127.0.0.1:5000/stream?t=2

# see puma stats
curl http://127.0.0.1:9293/stats?token=foo
```

# Notes

* nginx works with absolute file names only ([except relative to the --prefix passed at compile time](http://nginx.org/en/docs/configure.html)), thus we need to generate the nginx.conf at start. This is done in the `Procfile`.
