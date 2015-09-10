require "rack/test"
require "rspec"

require_relative "../lib/cleverbot"

ENV["RACK_ENV"] = "test"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  Sinatra::Application
end
