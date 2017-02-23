# frozen_string_literal: true

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

      if !STATUS_WITH_NO_ENTITY_BODY.include?(status) && headers[CONTENT_TYPE] =~ /\btext\/html\b/
        new_body = []
        new_content_length = 0

        body.each do |html|
          converter = HtmlConverter.new(html, app_env)
          next unless converter.valid_html?

          converter.insert_env_ribbon_into_body_tag!
          converter.insert_env_string_into_title_tag!
          converter.insert_env_ribbon_style_into_head_tag!

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
  end
end

require 'rack/env_ribbon/railtie' if defined?(Rails::Railtie)
