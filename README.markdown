# nginx + puma = scale

A minimal [Sinatra](sinatrarb.com) application fronted by nginx. Both communicate via Unix Domain Sockets, which should be more efficient than HTTP.

## Install Dependencies (once)

```
# Install OS packages like nginx
$ brew bundle

# Install rubygems
$ bundle install
```

## Start Monit

```
$ scripts/start
```

Monit will take care of starting all services it knows about.

## Check Status

```
$ monit summary
```

# Test

# App

```
$ curl -vvv localhost:5000/
…
# stream content for five seconds
$ curl -vvv localhost:5000/stream?t=5
…
# wait five seconds before returning the result
$ curl -vvv localhost:5000/slow?t=5
```

## Stress

```
# start
wrk --threads 12 --connections 60 --duration 60s --timeout 10 http://127.0.0.1:5000/stream?t=2

# see puma stats
curl http://127.0.0.1:9293/stats?token=foo
```

# Notes

* nginx and monit require with absolute file names (with the exception that nginx understands those [relative to the --prefix passed at compile time](http://nginx.org/en/docs/configure.html)), thus we need to generate the `nginx.conf` and `monitrc` before starting. This is done by all the scripts in `scripts` folder.
