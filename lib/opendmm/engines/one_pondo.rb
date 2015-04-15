require 'opendmm/movie'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module OnePondo
      def self.search(query)
        query = normalize(query)
        return unless query
        Movie.new(query).details
      end

      private

      def self.normalize(query)
        return unless query =~ /(1pon|一本道)/i
        return unless query =~ /(\d{6})[-_](\d{3})/i
        "#{$1}_#{$2}"
      end

      module Site
        include HTTParty
        base_uri 'www.1pondo.tv'

        def self.movie(query)
          get "/moviepages/#{query}/index.html"
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          super(query, Site.movie(query))

          @details.code            = "1pondo #{query}"
          @details.maker           = '一本道'
          @details.thumbnail_image = './images/thum_b.jpg'

          %w(./images/str.jpg ./images/popu.jpg).each do |url|
            url = URI.join(@details.base_uri, url).to_s
            @details.cover_image = url if Site.get(url).code == 200
          end

          @details.title         = @html.css('head > title').text.remove(/^.*「/, /」.*$/)
          @details.actresses     = @html.css('#profile-area > div > ul.bgoose > li > a > h2').map(&:text)
          @details.description   = @html.css('#profile-area > div.rr2').text
          @details.sample_images = @html.css('#movie-main > div.pics > table > tr > td > img').map do |img|
            img['src']
          end
        end
      end
    end
  end
end