# nginx + puma = scale

A minimal [Sinatra](sinatrarb.com) application fronted by nginx. Both communicate via Unix Domain Sockets, which should be more efficient than HTTP.

## Start

```
$ erb nginx.conf.erb > nginx.conf
$ nginx -c $(realpath nginx.conf)
$ bundle exec puma -b unix://app.sock
```

## Test

```
$ curl -vvv localhost:8088/
…
# stream content for five seconds
$ curl -vvv localhost:8088/stream?t=5
…
# wait five seconds before returning the result
$ curl -vvv localhost:8088/slow?t=5
```

## Reload Config

```
nginx -c $(realpath nginx.conf) -s reload
```

# Notes
* nginx works with fully qualified file names only, thus we need to generate the nginx.conf

# TODO
* Use [foreman](http://ddollar.github.io/foreman/) to start the Ruby app and nginx together
