# Sample app for Withings OAuth2 Strategy
# Make sure to setup the ENV variables WITHINGS_CLIENT_ID and WITHINGS_CLIENT_SECRET
# Run with "bundle exec rackup"

require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-withings'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/withings'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env['omniauth.auth'])
  end

  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie, :secret => 'change_me'

use OmniAuth::Builder do
  provider :withings, ENV['WITHINGS_CLIENT_ID'], ENV['WITHINGS_CLIENT_SECRET'], scope: 'user.info user.metrics user.activity'
end

run App.new
