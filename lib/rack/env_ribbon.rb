require 'rack/env_ribbon/html_converter'

module Rack
  class EnvRibbon
    def initialize(app, opts = {})
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      new_body = []

      if headers[CONTENT_TYPE] =~ /\btext\/html\b/
        body.each do |b|
          converter = HtmlConverter.new(b, app_env)
          next unless converter.valid?
          converter.insert_env_ribbon_into_body
          converter.insert_env_string_into_title
          converter.insert_env_ribbon_style_into_head
          new_body << converter.result
        end

        unless new_body.empty?
          body = new_body
          content_length = body.map(&:bytesize).inject(&:+)
          headers[CONTENT_LENGTH] &&= content_length.to_s
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
