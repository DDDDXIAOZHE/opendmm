require 'cgi'
require 'opendmm/movie'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module Heyzo
      def self.search(query)
        query = normalize(query)
        return unless query
        Movie.new(query).details
      end

      private

      def self.normalize(query)
      end

      module Site
        include HTTParty
        base_uri 'www.heyzo.com'

        def self.movie(query)
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          super(query, Site.movie(query))
        end
      end
    end
  end
end