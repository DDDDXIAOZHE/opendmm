require 'opendmm/movie'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module DMM
      def self.search(query)
        queries = normalize(query)
        LOGGER.debug queries
        queries.lazy.map do |query|
          begin
            Movie.new(query).details
          rescue StandardError => e
            LOGGER.debug query
            LOGGER.debug e
            LOGGER.debug e.backtrace
            nil
          end
        end.find(&:present?)
      end

      private

      def self.normalize(query)
        query.scan(/(?<!S2)([a-z]{2,6})-?(\d{2,5})/i).map do |pair|
          alpha = pair[0].upcase
          5.downto(3).map do |len|
            digit = pair[1].rjust(len, '0')
            "#{alpha}#{digit}"
          end
        end.flatten
      end

      module Site
        include HTTParty
        base_uri 'www.dmm.co.jp'

        def self.search(query)
          get "/search/=/searchstr=#{CGI::escape(query)}"
        end
      end

      class Search
        def initialize(query, response)
          @query = query
          @response = response
          @html = Nokogiri.HTML @response
        end

        def result
          candidate = @html.at_css('#list > li > div > p.tmb > a')['href']
          URI.join(@response.request.last_uri.to_s, candidate).to_s
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          search = Search.new(query, Site.search(query))
          super(query, Site.get(search.result))

          @details.thumbnail_image = @html.at_css('#sample-video img')['src']
          @details.title           = @html.css('#title').text
          begin
            @details.cover_image   = @html.at_css('#sample-video a')['href']
          rescue StandardError
            @details.cover_image   = @details.thumbnail_image
          end

          details_table = @html.at_xpath('//div[@class="page-detail"]/table/tr/td[1]/table')
          details_table.css('tr').each do |tr|
            first = tr.css('td')[0]
            second = tr.css('td')[1]
            case first.text
            when /配信開始日/
              @details.release_date = second.text
            when /収録時間/
              @details.movie_length = second.text
            when /出演者/
              @details.actresses = second.css('span').map(&:text)
            when /監督/
              @details.directors = second.css('span').map(&:text)
            when /シリーズ/
              @details.series = second.text
            when /メーカー/
              @details.maker = second.text
            when /レーベル/
              @details.label = second.text
            when /ジャンル/
              @details.genres = second.css('span').map(&:text)
            when /品番/
              if second.text =~ /([a-z]+)(\d+)/i
                @details.code = "#{$1.upcase}-#{$2.to_i.to_s.rjust(3, '0')}"
              else
                @details.code = second.text
              end
            end
          end

          @details.description = details_table.next_element.next_element.xpath('text()').text
        end
      end
    end
  end
end