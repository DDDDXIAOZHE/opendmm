require 'opendmm/movie'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module Caribbean
      def self.search(query)
        query = normalize(query)
        return unless query
        Movie.new(query).details
      end

      private

      def self.normalize(query)
        return unless query =~ /(carib|カリビアンコム|加勒比)/i
        return unless query =~ /(\d{6})[-_](\d{3})/i
        "#{$1}-#{$2}"
      end

      module Site
        include HTTParty
        base_uri 'www.caribbeancom.com'

        def self.movie(query)
          get "/moviepages/#{query}/index.html"
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query)
          super(query, Site.movie(query))

          @details.code            = "Carib #{query}"
          @details.cover_image     = './images/l_l.jpg'
          @details.maker           = 'Caribbean'
          @details.thumbnail_image = './images/l_s.jpg'

          @details.title           = @html.css('#main-content > div.main-content-movieinfo > div.video-detail > span.movie-title').text
          @details.description     = @html.css('#main-content > div.main-content-movieinfo > div.movie-comment').text
          @details.sample_images   = @html.css('#main-content > div.detail-content.detail-content-gallery-old > table > tr > td > a').map do |a|
            a['href']
          end.reject do |url|
            url.include? '/member/'
          end

          @html.css('#main-content > div.main-content-movieinfo > div.movie-info > dl').map do |dl|
            case dl.at_css('dt').text
            when '出演:'
              @details.actresses = dl.css('dd').map(&:text)
            when 'カテゴリー:'
              @details.categories = dl.css('dd').map(&:text)
            when '配信日:'
              @details.release_date = dl.css('dd').text
            when '再生時間:'
              @details.movie_length = dl.css('dd').text
            end
          end
        end
      end

      module SitePr
        include HTTParty
        base_uri 'www.caribbeancompr.com'

        def self.movie(query)
          get "/moviepages/#{query}/index.html"
        end
      end

      class MoviePr < OpenDMM::Movie
        def initialize(query)
          super(query, SitePr.movie(query))

          @details.code            = "Caribpr #{query}"
          @details.cover_image     = './images/l_l.jpg'
          @details.thumbnail_image = './images/main_b.jpg'
          @details.title           = @html.css('#main-content > div.main-content-movieinfo > div.video-detail').text
          @details.description     = @html.css('#main-content > div.main-content-movieinfo > div.movie-comment').text
          @details.sample_images   = @html.css('#main-content > div.detail-content.detail-content-gallery > ul > li > div > a').map do |a|
            a['href']
          end.reject do |url|
            url.include? '/member/'
          end

          @html.css('#main-content > div.main-content-movieinfo > div.movie-info > dl').map do |dl|
            case dl.at_css('dt').text
            when '出演:'
              @details.actresses = dl.css('dd').map(&:text)
            when 'カテゴリー:'
              @details.categories = dl.css('dd').map(&:text)
            when '販売日:'
              @details.release_date = dl.css('dd').text
            when '再生時間:'
              @details.movie_length = dl.css('dd').text
            when 'スタジオ:'
              @details.maker = dl.css('dd').text
            when 'シリーズ:'
              @details.series = dl.css('dd').text
            end
          end
        end
      end
    end
  end
end