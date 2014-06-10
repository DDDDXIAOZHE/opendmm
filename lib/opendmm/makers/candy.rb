module OpenDMM
  module Maker
    module Candy
      include Maker

      module Site
        include HTTParty
        base_uri "candy-av.com"

        def self.item(name)
          case name
          when /(CND)-?(\d{3})/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css('#actress > div > dl'))
          return {
            actresses:     specs['出演女優'].css('a').map(&:text),
            code:          specs['品番'].text,
            cover_image:   URI.join(page_uri, html.xpath('//*[@id="thumbnail"]/a[1]').first['href']).to_s,
            description:   html.css('#brand > p.p_actress_detail').text,
            genres:        specs['ジャンル'].css('a').map(&:text),
            movie_length:  ChronicDuration.parse(specs['収録時間']),
            page:          page_uri.to_s,
            release_date:  Date.parse(specs['発売日'].text),
            sample_images: html.css('#brand > div.photo_sumple > ul > li > a').map { |a| URI.join(page_uri, a['href']).to_s },
            series:        specs['シリーズ'].text,
            title:         html.css('#brand > div.m_t_4 > h3').text,
          }
        end
      end
    end
  end
end
