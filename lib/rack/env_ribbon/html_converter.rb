# frozen_string_literal: true

module Rack
  class EnvRibbon
    class HtmlConverter
      attr_reader :html, :env

      def initialize(html, env)
        @html = html
        @env = env.to_s
      end

      def valid_html?
        has_tag?('html') && has_tag?('body')
      end

      def insert_env_string_into_title_tag!
        tag = 'title'
        insert_into(tag, "(#{env}) ") if has_tag?(tag)
      end

      def insert_env_ribbon_style_into_head_tag!
        css = ::File.open(::File.join(assets_path, 'stylesheets/env_ribbon.css'))
        content = "<style>#{css.read}</style>"
        css.close
        insert_into('head', content, last_line: true, new_line: true)
      end

      def insert_env_ribbon_into_body_tag!
        content = "<a class=\"github-fork-ribbon left-top red fixed\" onClick=\"this.style.display='none'\" title=\"#{env}\">#{env}</a>"
        insert_into('body', content, new_line: true)
      end

      def result
        html
      end

      private

      def start_tag_regexp(tag)
        /(<#{tag}[^>]*>)/i
      end

      def end_tag_regexp(tag)
        /(<\/#{tag}>)/i
      end

      def has_tag?(tag)
        !!(html =~ start_tag_regexp(tag) && html =~ end_tag_regexp(tag))
      end

      def insert_into(tag, content, last_line: false, new_line: false)
        if last_line
          content_placement = new_line ?  "\n#{content}\n\\1" : "#{content}\\1"
          html.sub!(end_tag_regexp(tag), content_placement)
        else
          content_placement = new_line ?  "\n\\1#{content}\n" : "\\1#{content}"
          html.sub!(start_tag_regexp(tag), content_placement)
        end
      end

      def assets_path
        ::File.expand_path('../../../vendor/assets', __dir__)
      end
    end
  end
end
