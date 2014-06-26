module OpenDMM
  module Maker
    module Cross
      include Maker

      module Site
        include HTTParty
        base_uri 'crosscross.jp'

        def self.item(name)
          case name
          when /(CRAD|CRPD|CRSS)-?(\d{3})/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css('#details > div > dl'))
          return {
            actresses:       specs['出演女優'].css('a').map(&:text),
            code:            specs['品番'].text,
            cover_image:     html.at_css('#pake')['href'],
            description:     html.css('#details > div > p.story').text,
            directors:       specs['監督'].css('a').map(&:text),
            genres:          specs['ジャンル'].css('a').map(&:text),
            movie_length:    specs['収録時間'].text,
            page:            page_uri.to_s,
            release_date:    specs['発売日'].text,
            sample_images:   html.css('#sample-pic > li > a').map { |a| a['href'] },
            series:          specs['シリーズ'].text,
            thumbnail_image: html.at_css('#pake > img')['src'],
            title:           html.css('#details > div > h3').text,
          }
        end
      end
    end
  end
end
