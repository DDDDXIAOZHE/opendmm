module OpenDMM
  module Maker
    module KiraKira
      include Maker

      module Site
        include HTTParty
        base_uri 'kirakira-av.com'

        def self.item(name)
          case name
          when /(BLK|KIRD|KISD|SET)-?(\d{3})/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.xpath('//*[@id="details_main"]/dl'))
          return {
            actresses:       specs['出演女優'].text.split('/'),
            code:            specs['品番'].text,
            cover_image:     html.css('#img_pm > img').first['src'].gsub(/pm\.jpg$/, 'pl.jpg'),
            description:     html.css('//*[@id="details_main"]/p[1]').text,
            genres:          specs['ジャンル'].text.split('/'),
            label:           specs['レーベル'].text,
            movie_length:    specs['収録時間'].text.remove('DVD/'),
            page:            page_uri.to_s,
            release_date:    specs['発売日'].text,
            sample_images:   html.css('#sample-pic > li > a > img').map { |img| img['src'].gsub(/js(?=-\d+\.jpg)/, 'jp') },
            series:          specs['シリーズ'].text,
            thumbnail_image: html.css('#img_pm > img').first['src'],
            title:           html.css('#details_main > h2').text,
          }
        end
      end
    end
  end
end
