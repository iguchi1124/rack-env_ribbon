require 'rack/env_ribbon/html_converter'

module Rack
  class EnvRibbon
    def initialize(app, opts = {})
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      if headers[CONTENT_TYPE] =~ /\btext\/html\b/
        new_body = []

        # The response body must respond to each.
        body.each do |html|
          converter = HtmlConverter.new(html, app_env)
          next unless converter.valid?
          converter.insert_env_ribbon_into_body
          converter.insert_env_string_into_title
          converter.insert_env_ribbon_style_into_head
          new_body << converter.result
        end

        new_body.compact!

        unless new_body.empty?
          body = new_body
          headers[CONTENT_LENGTH] &&= body.map(&:bytesize).inject(&:+).to_s
        end
      end

      [status, headers, body]
    end

    private

    def app_env
      @app_env ||= ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    end
  end
end
