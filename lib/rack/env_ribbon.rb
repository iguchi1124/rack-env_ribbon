require 'rack/utils'
require 'rack/env_ribbon/html_converter'

module Rack
  class EnvRibbon
    include Rack::Utils

    def initialize(app, opts = {})
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers = HeaderHash.new(headers)

      if applicable?(status, headers)
        new_body = []
        new_content_length = 0

        # The response body must respond to `each` method.
        body.each do |html|
          converter = HtmlConverter.new(html, app_env)
          next unless converter.valid_html?

          converter.insert_env_ribbon_into_body
          converter.insert_env_string_into_title
          converter.insert_env_ribbon_style_into_head
          result = converter.result

          new_body << result
          new_content_length += result.bytesize
        end

        new_body.compact!

        unless new_body.empty?
          body = new_body
          headers[CONTENT_LENGTH] &&= new_content_length
        end
      end

      [status, headers, body]
    end

    private

    def app_env
      @app_env ||= ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    end

    def applicable?(status, headers)
      !STATUS_WITH_NO_ENTITY_BODY.include?(status) &&
        headers[CONTENT_TYPE] =~ /\btext\/html\b/
    end
  end
end

require 'rack/env_ribbon/railtie' if defined?(Rails::Railtie)
