require 'sinatra'

require 'rack/env_ribbon'

use Rack::EnvRibbon

get '/' do
  <<-HTML
  <!DOCTYPE html>
  <html lang="ja">
  <head>
      <meta charset="utf-8">
      <title>sinatra app</title>
  </head>
  <body>
      <p>body</p>
  </body>
  </html>
  HTML
end
