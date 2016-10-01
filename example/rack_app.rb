require 'rack'
require 'rack/env_ribbon'

class Application
  def call(env)
      [200, {'Content-Type' => 'text/html'}, ['<html><head><title></title></head><body></body></html>']]
  end
end

app = Rack::Builder.new do
  use Rack::EnvRibbon
  run Application.new
end

Rack::Handler::WEBrick.run app
