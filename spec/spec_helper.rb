require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'rack/env_ribbon'

ENV['RACK_ENV'] = 'test'

require File.expand_path 'app.rb', __dir__

def app
  Rack::Builder.new do
    use Rack::EnvRibbon
    run Application.new
  end
end

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.configure do |config|
  config.app = app
  config.javascript_driver = :poltergeist
  config.default_driver = :poltergeist
  config.app_host = 'http://localhost:3000'
  config.server_port = 3000
end
