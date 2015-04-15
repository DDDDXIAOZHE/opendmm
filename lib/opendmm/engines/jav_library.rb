require 'cgi'
require 'opendmm/movie'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module JavLibrary
      def self.search(query)
        queries = normalize(query)
        LOGGER.debug queries
        queries.lazy.map do |query|
          begin
            Movie.new(query).details
          rescue StandardError => e
            LOGGER.debug query
            LOGGER.debug e
            nil
          end
        end.find(&:present?)
      end

      private

      def self.normalize(query)
        query.scan(/(?<!S2)([a-z]{2,6})-?(\d{2,5})/i).map do |pair|
          "#{pair[0].upcase}-#{pair[1]}"
        end
      end

      module Site
        include HTTParty
        base_uri 'www.javlibrary.com'

        def self.search(query)
          get "/ja/vl_searchbyid.php?keyword=#{CGI::escape(query)}"
        end
      end

      class Search
        def initialize(query, response)
          @query = query
          @response = response
          @html = Nokogiri.HTML @response
        end

        def result
          candidate = (@response.code == 302) ? @response.headers['location']
                                              : best_candidate
          URI.join(@response.request.last_uri.to_s, candidate).to_s
        end

        private

        def best_candidate
          candidates = @html.css('#rightcolumn > div.videothumblist > div.videos > div.video > a')
          best = candidates.detect do |candidate|
            candidate.css('div.id').text == @query
          end || candidates.first
          best['href'] if best
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          search = Search.new(query, Site.search(query))
          super(query, Site.get(search.result))

          @details.code         = @html.css('#video_id .text').text
          @details.title        = @html.css('#video_title > h3').text.remove(@details.code)
          @details.cover_image  = @html.at_css('#video_jacket > img')['src']
          @details.release_date = @html.css('#video_date .text').text
          @details.movie_length = @html.css('#video_length .text').text + ' minutes'
          @details.directors    = @html.css('#video_director .text span.director').map(&:text)
          @details.maker        = @html.css('#video_maker .text').text
          @details.label        = @html.css('#video_label .text').text
          @details.genres       = @html.css('#video_genres .text span.genre').map(&:text)
          @details.actresses    = @html.css('#video_cast .text span.cast span.star').map(&:text)
        end
      end
    end
  end
end