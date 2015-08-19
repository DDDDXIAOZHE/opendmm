require 'opendmm/movie'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module TokyoHot
      def self.search(query)
        query = normalize(query)
        return unless query
        Movie.new(query).details
      end

      private

      def self.normalize(query)
        return unless query =~ /(k|n)(\d{3,4})/
        "#{$1}#{$2.rjust(4, '0')}"
      end

      module Site
        include HTTParty
        base_uri 'www.tokyo-hot.com'

        def self.search(query)
          get "http://www.tokyo-hot.com/product/?q=#{CGI::escape(query)}"
        end
      end

      class Search
        def initialize(query, response)
          @query = query
          @response = response
          @html = Nokogiri.HTML @response
        end

        def result
          candidate = @html.at_css('#main > ul > li > a')['href']
          URI.join(@response.request.last_uri.to_s, candidate).to_s
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          search = Search.new(query, Site.search(query))
          super(query, Site.get(search.result))

          @details.maker = 'Tokyo Hot'

          @details.title = @html.at_css('#container > div.pagetitle > h2').text
          @details.cover_image = @html.at_css('#container > div.movie.cf > div.in > div.flowplayer > video')['poster']
          @details.description = @html.at_css('#main > div.contents > div.sentence').text

          @html.css('#main > div.contents > div.infowrapper > dl > dt').each do |dt|
            dd = dt.next_element
            case dt.text
            when /出演者/
              @details.actresses = dd.css('a').map(&:text)
            when /シリーズ/
              @details.series = dd.text
            when /カテゴリ/
              @details.categories = dd.css('a').map(&:text)
            when /配信開始日/
              @details.release_date = dd.text
            when /収録時間/
              @details.movie_length = dd.text
            when /作品番号/
              @details.code = 'Tokyo Hot ' + dd.text
            end
          end

          @details.sample_images = @html.css('#main > div.contents > div.scap > a,
                                              #main > div.contents > div.vcap > a').map { |a| a['href'] }
        end
      end
    end
  end
end