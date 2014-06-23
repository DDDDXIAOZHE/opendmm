require 'active_support/core_ext/string/filters'
require 'httparty'
require 'logger'
require 'nokogiri'
require 'opendmm/utils'

module OpenDMM
  module Maker
    @@makers = []

    def self.included(klass)
      klass.module_eval <<-CODE
        module Site
          include HTTParty
          follow_redirects false

          def self.get(uri)
            super(uri)
          rescue Errno::ETIMEDOUT => e
            tries ||= 0
            tries++
            tries <= 5 ? retry : raise
          end
        end

        def self.search(name)
          item = Site.item(name)
          Parser.parse(item) if item && item.code == 200
        end
      CODE
      @@makers << klass
    end

    # Known fields:
    #
    # {
    #   actresses:       Array
    #   actress_types:   Array
    #   boobs:           String
    #   brand:           String
    #   categories:      Array
    #   code:            String
    #   cover_image:     String
    #   description:     String
    #   directors:       Array
    #   genres:          Array
    #   label:           String
    #   maker:           String
    #   movie_length:    String
    #   page:            String
    #   release_date:    String
    #   sample_images:   Array
    #   scenes:          Array
    #   series:          String
    #   subtitle:        String
    #   theme:           String
    #   thumbnail_image: String
    #   title:           String
    #   __extra:         Hash
    # }

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
