require 'bundler/setup'
Bundler.require :default, :test

Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false

require File.join(File.dirname(__FILE__), '..', 'app.rb')

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
