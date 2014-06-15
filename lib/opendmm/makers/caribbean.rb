module OpenDMM
  module Maker
    module Caribbean
      include Maker

      module Site
        include HTTParty
        base_uri 'www.caribbeancom.com'

        def self.item(name)
          case name
          when /Carib ?(\d{6})[-_](\d{3})/i
            get("/moviepages/#{$1}-#{$2}/index.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css('#main-content > div.main-content-movieinfo > div.movie-info > dl').map(&:text))
          return {
            actresses:       specs['出演'].split,
            categories:      specs['カテゴリー'].split,
            code:            "Carib " + page_uri.to_s.match(/\d{6}-\d{3}/)[0],
            cover_image:     "./images/l_l.jpg",
            description:     html.css('#main-content > div.main-content-movieinfo > div.movie-comment').text,
            movie_length:    specs['再生時間'],
            page:            page_uri.to_s,
            release_date:    specs['配信日'],
            sample_images:   html.css('#main-content > div.detail-content.detail-content-gallery-old > table > tr > td > a').map{ |a| a['href'] }.reject{ |uri| uri =~ /\/member\// },
            thumbnail_image: "./images/l_s.jpg",
            title:           html.css('#main-content > div.main-content-movieinfo > div.video-detail > span.movie-title > h1').text,
          }
        end
      end
    end
  end
end
