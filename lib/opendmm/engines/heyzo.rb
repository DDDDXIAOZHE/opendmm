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
        return unless query =~ /heyzo/i
        return unless query =~ /(\d{3,4})/i
        $1.rjust(4, '0')
      end

      module Site
        include HTTParty
        base_uri 'www.heyzo.com'

        def self.movie(query)
          get "/moviepages/#{query}/index.html"
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          super(query, Site.movie(query))

          @details.code          = "Heyzo #{query}"
          @details.cover_image   = "/contents/3000/#{query}/images/player_thumbnail_450.jpg"
          @details.maker         = 'Heyzo'

          @details.title         = @html.css('#movie > h1').text
          @details.release_date  = @html.css('#movie > div.info-bg.info-bgWide > div > span.release-day + *').text
          @details.actresses     = @html.css('#movie > div.info-bg.info-bgWide > div > span.actor + *').text.split
          @details.label         = @html.css('#movie > div.info-bg.info-bgWide > div > span.label + *').text.remove(/-+/)
          @details.actress_types = @html.css('#movie > div.info-bg.info-bgWide > div > div.actor-type > span').map(&:text)
          @details.tags          = @html.css('#movie > div.info-bg.info-bgWide > div > div.tag_cloud > ul > li').map(&:text)
          @details.description   = @html.css('#movie > div.info-bg.info-bgWide > div > p').text
        end
      end
    end
  end
end