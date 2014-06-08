require "active_support/core_ext/string/filters"
require "chronic_duration"
require "httparty"
require "nokogiri"
require "opendmm/utils"

module OpenDMM
  module Maker
  	@@makers = []

  	def self.included(klass)
      klass.module_eval <<-CODE
        def self.search(name)
          item = Site.item(name)
          item ? Parser.parse(item) : nil
        end
      CODE
  	  @@makers << klass
  	end

  	# Known fields:
  	#
  	# {
  	#   actresses:     Array
  	#   actress_types: Array
  	#   brand:         String
  	#   code:          String
  	#   cover_image:   String
  	#   description:   String
  	#   directors:     Array
  	#   genres:        Array
  	#   label:         String
  	#   maker:         String
  	#   movie_length:  String
  	#   page:          String
  	#   release_date:  String
  	#   sample_images: Array
  	#   scenes:        Array
  	#   series:        String
  	#   title:         String
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
