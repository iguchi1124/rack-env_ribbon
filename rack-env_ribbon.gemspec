$:.push File.expand_path('../lib', __FILE__)

require 'rack/env_ribbon/version'

Gem::Specification.new do |s|
  s.name        = 'rack-env_ribbon'
  s.version     = Rack::EnvRibbon::VERSION
  s.authors     = ['Shota Iguchi']
  s.email       = ['shota-iguchi@cookpad.com']
  s.homepage    = 'https://github.com/iguchi1124/rack-env_ribbon'
  s.summary     = 'Add env ribbon on your rack application views.'
  s.license     = 'MIT'

  s.files = Dir['{lib,vendor}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rack'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-byebug'
end
