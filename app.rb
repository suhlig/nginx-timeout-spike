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

  before do
    content_type 'text/plain'
  end

  use RequestID

  get '/' do
    "Hello #{request_id} from nginx!"
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
    out << "Welcome visitor #{request_id}; sending #{count} parts to you:\n"

    count.times do |i|
      puts "#{request_id} - sending #{i} of #{count}"
      out << "#{i}\n"
      sleep 1
    end

    out
  end

  def request_id
    request.env['VCAP_REQUEST_ID']
  end
end
