nginx: erb nginx.conf.erb > nginx.conf && nginx -c $(realpath nginx.conf)
app: bundle exec puma --bind unix://app.sock
