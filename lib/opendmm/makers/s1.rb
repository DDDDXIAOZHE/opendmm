module OpenDMM
  module Maker
    module S1
      include Maker

      module Site
        include HTTParty
        base_uri 's1s1s1.com'

        def self.item(name)
          case name
          when /(ONSD|SNIS|SOE|SPS)-?(\d{3})/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.xpath('//*[@id="contents"]/dl'))
          return {
            actresses:       specs['女優'].text.split,
            code:            html.xpath('//*[@id="order"]/tr[1]/td[1]').text,
            cover_image:     html.xpath('//*[@id="slide-photo"]/div[@class="slide pake"]/img').first['src'],
            description:     html.css('#contents > p.tx-comment').text,
            directors:       specs['監督'].text.split,
            genres:          specs['ジャンル'].css('a').map(&:text),
            page:            page_uri.to_s,
            release_date:    specs['発売日'].text,
            sample_images:   html.xpath('//*[@id="slide-photo"]/div[contains(@class, "slide") and not(contains(@class, "pake"))]/img').map { |img| img['src'] },
            series:          specs['シリーズ'].text,
            thumbnail_image: html.css('#slide-thumbnail > ul.ts_container > li.ts_thumbnails > div.ts_preview_wrapper > ul.ts_preview > li > img').first['src'],
            title:           html.css('#contents > h1').text,
          }
        end
      end
    end
  end
end
