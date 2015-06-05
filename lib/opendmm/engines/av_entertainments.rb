require 'cgi'
require 'opendmm/movie'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module AvEntertainments
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
        query.scan(/((?:S2|2D|3D|[a-z]){2,6}?)[-_\s]?(S?\d{2,5})/i).map do |pair|
          alpha = pair[0].upcase
          digit = pair[1]
          case alpha
          when /SMBD/, /CWPBD/
            digit = digit.to_i.to_s.rjust(2, '0')
          end
          "#{alpha}-#{digit}"
        end
      end

      module Site
        include HTTParty
        base_uri 'www.aventertainments.com'
        headers({
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36"
        })

        def self.search(query)
          get "/search_Products.aspx?keyword=#{CGI::escape(query)}"
        end
      end

      class Search
        def initialize(query, response)
          @query = query
          @response = response
          @html = Nokogiri.HTML @response
        end

        def result
          @html.at_css('div.main-unit2 > table a')['href']
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          search = Search.new(query, Site.search(query))
          super(query, Site.get(search.result))

          @details.title       = @html.css('#mini-tabet > h2').text
          @details.cover_image = @html.at_css('#titlebox > div.list-cover > img')['src'].gsub('jacket_images', 'bigcover')
          @details.code        = @html.css('#mini-tabet > div').text.remove('商品番号:')
          @details.categories  = @html.xpath('//*[@id="TabbedPanels1"]/div/div[2]/div[2]//ol').map(&:text)

          @html.css('#titlebox > ul > li').each do |li|
            case li.css('span').text
            when /主演女優/
              @details.actresses = li.css('a').map(&:text)
            when /スタジオ/
              @details.maker = li.css('a').text
            when /シリーズ/
              @details.series = li.css('a').text
            when /発売日/
              @details.release_date = li.text
            when /収録時間/
              @details.movie_length = li.text
            end
          end
        end
      end
    end
  end
end