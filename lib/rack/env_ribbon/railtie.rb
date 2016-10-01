require 'rails'
require 'rack/env_ribbon'

module Rack
  class EnvRibbon
    class Railtie < Rails::Railtie
      initializer 'rack-env_ribbon' do
        config.app_middleware.use Rack::EnvRibbon
      end
    end
  end
end
