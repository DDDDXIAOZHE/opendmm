require 'cgi'
require 'opendmm/movie'
require 'opendmm/search'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module JavLibrary
      def self.search(query)
        search = Search.new(Site.search(query), query)
        movie = Movie.new(Site.get(search.result))
        movie.details
      end

      private

      module Site
        include HTTParty
        base_uri 'www.javlibrary.com'

        def self.search(query)
          get "/ja/vl_searchbyid.php?keyword=#{CGI::escape(query)}"
        end
      end

      class Search < OpenDMM::Search
        def initialize(page, query)
          super
          @result = (@page.code == 302) ? @page.headers['location']
                                        : best_candidate
        end

        def best_candidate
          candidates = @html.css('#rightcolumn > div.videothumblist > div.videos > div.video > a')
          best = candidates.detect do |candidate|
            candidate.css('div.id').text == @query
          end || candidates.first
          best['href']
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(page)
          super
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