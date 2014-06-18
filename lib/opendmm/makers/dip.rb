module OpenDMM
  module Maker
    module Dip
      include Maker

      module Site
        include HTTParty
        base_uri 'dip-av.jp'

        def self.item(name)
          case name
          when /(NPS|PTS|ZEX)-?(\d{3})/i
            get("/detail.php?hinban=#{$1.upcase}-#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css('#main > div.detail > div.actor').map(&:text)).merge(
                  Utils.hash_by_split(html.xpath('//*[@id="main"]/div[@class="detail"]/div[not(@class)]').text.lines))
          return {
            actresses:       specs['出演者'].try(:split),
            code:            specs['品番'],
            cover_image:     html.at_css('#main > div.detail > a')['href'],
            description:     html.css('#main > div.detail > div.comment').text,
            genres:          specs['ジャンル'].try(:split),
            label:           specs['レーベル'],
            maker:           specs['メーカー'],
            movie_length:    specs['収録時間'],
            page:            page_uri.to_s,
            release_date:    specs['品番'],
            series:          specs['シリーズ'],
            thumbnail_image: html.at_css('#main > div.detail > a > img')['src'],
            title:           html.css('#main > h1').text,
          }
        end
      end
    end
  end
end
