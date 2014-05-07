require "active_support/core_ext/string/filters"
require "chronic_duration"
require "httparty"
require "nokogiri"
require "opendmm/utils"

module OpenDMM
  module Maker
    @@makers = []

    def self.included(mod)
      @@makers << mod
    end

    def self.search(name)
      @@makers.each do |maker|
        result = maker.search(name)
        return result if result
      end
      nil
    end
  end
end

Dir[File.dirname(__FILE__) + '/makers/*.rb'].each do |file|
  require file
end
