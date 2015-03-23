require 'active_support/core_ext/string/filters'
require 'nokogiri'

module OpenDMM
  module Nokogiri
    def self.HTML(content)
      encoding = ::Nokogiri.HTML(content).encoding
      content = content.encode('UTF-8', encoding, invalid: :replace, undef: :replace, replace: '')
      ::Nokogiri.HTML(content).tap do |html|
        html.css('script').remove
      end
    end
  end
end
