require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'puma'
require 'rack/env_ribbon'
require 'selenium-webdriver'

ENV['RACK_ENV'] = 'test'

require File.expand_path 'dummy/app.rb', __dir__

app = Rack::Builder.new do
  use Rack::EnvRibbon
  run Application.new
end

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      chrome_options: {
        args: %w(headless disable-gpu window-size=1920,1080),
      },
    )
  )
end

Capybara.configure do |config|
  config.app = app
  config.javascript_driver = :selenium
  config.default_driver = :selenium
  config.app_host = 'http://localhost:3000'
  config.server = :puma
  config.server_port = 3000
end
