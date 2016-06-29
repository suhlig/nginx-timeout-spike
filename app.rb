require "rubygems"
require "sinatra/base"

class RequestID
  def initialize(app)
    @app = app
  end

  def call(env)
    env["VCAP_REQUEST_ID"] = SecureRandom.uuid
    @app.call(env)
  end
end

class App < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  use RequestID

  get '/' do
    'Hello, nginx!'
  end

  # this is affected proxy_read_timeout
  get '/slow' do
    produce('')
  end

  # not affected by proxy_read_timeout
  get '/stream' do
    stream do |out|
      produce(out)
    end
  end

  def count
    (params[:t] || 1).to_i
  end

  def produce(out)
    out << "Sending #{count} parts:<br/>\n"

    count.times do |i|
      puts "#{request.env['VCAP_REQUEST_ID']} - sending #{i} of #{count}"
      out << "#{i}<br/>\n"
      sleep 1
    end

    out
  end
end
