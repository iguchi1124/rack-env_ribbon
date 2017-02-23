require 'rack'
require 'rack/env_ribbon'

class Application
  def call(env)
    status = 200
    headers = { 'Content-Type' => 'text/html' }
    html = <<~EOS
        <html>
          <head>
            <title>sample app</title>
          </head>
          <body>
            <p>app body</p>
          </body>
        </html>
      EOS

    [status, headers, [html]]
  end
end

app = Rack::Builder.new do
  use Rack::EnvRibbon
  run Application.new
end

Rack::Handler::WEBrick.run app
