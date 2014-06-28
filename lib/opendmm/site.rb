require 'active_support/core_ext/module/attribute_accessors'
require 'httparty'
require 'opendmm/utils'

module OpenDMM
  module Site

    def self.included(klass)
      klass.mattr_accessor :url_generators
      klass.mattr_accessor :code_generators
      klass.url_generators = Hash.new
      klass.code_generators = Hash.new

      klass.include HTTParty
      klass.follow_redirects false

      klass.extend ClassMethods
    end

    module ClassMethods
      def get_with_retry(url, limit = 5)
        return nil unless url
        get url
      rescue Errno::ETIMEDOUT => e
        tries ||= 0
        tries++
        tries <= 5 ? retry : raise
      end

      def register_product(matcher, url_generator, code_generator = '#{$1.upcase}-#{$2}')
        url_generators[matcher] = '"' + url_generator + '"'
        code_generators[matcher] = '"' + code_generator + '"'
      end

      def product_url(name)
        url_generators.each do |matcher, url_generator|
          if name =~ matcher
            return eval url_generator
          end
        end
        nil
      end

      def product_code(name)
        code_generators.each do |matcher, code_generator|
          if name =~ matcher
            return eval code_generator
          end
        end
        nil
      end

      def product_extra_info(name, url, page, html)
        Hash.new
      end

      def product(name)
        url = product_url name
        page = get_with_retry url
        return nil unless page
        html = Utils.html_in_utf8 page
        details = parse_product_html html
        details[:code] ||= product_code name
        details[:page] ||= page.request.last_uri.to_s
        extra_info = product_extra_info(name, url, page, html)
        extra_info.each do |k, v|
          details[k] ||= v
        end
        Utils.finalize_details_hash details
      end
    end
  end
end
