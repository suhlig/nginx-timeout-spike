nginx: erb nginx.conf.erb > nginx.conf && nginx -c $(realpath nginx.conf)
app: bundle exec puma --bind unix://app.sock --control tcp://127.0.0.1:9293 --control-token foo
