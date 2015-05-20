require 'opendmm/movie'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module MGStage
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
        base_uri 'www.mgstage.com'
        cookies(adc: 1, coc: 1)
        headers({
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36"
        })

        def self.movie(query)
          get "/ppv/video/#{query}/"
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          super(query, Site.movie(query))

          @details.title = @html.css('.title_detail_layout h1').text
          @details.cover_image = @html.at_css('a.enlarge_image')['href']
          @details.thumbnail_image = @html.at_css('a.enlarge_image > img')['src']
          @details.description = @html.css('#introduction_text > p.introduction').text
          @details.sample_images = @html.css('a.sample_imageN').map { |a| a['href'] }

          @html.css('#CONTENT_DETAIL dl.spec_layout dt').each do |dt|
            dd = dt.next_element
            case dt.text
            when /配信開始日/
              @details.release_date = dd.text
            when /収録時間/
              @details.movie_length = dd.text
            when /品番/
              @details.code = dd.text
            when /出演/
              @details.actresses = dd.css('a').map(&:text)
            when /メーカー/
              @details.maker = dd.text
            when /シリーズ名/
              @details.series = dd.text
            when /ジャンル/
              @details.genres = dd.css('a').map(&:text)
            end
          end
        end
      end
    end
  end
end