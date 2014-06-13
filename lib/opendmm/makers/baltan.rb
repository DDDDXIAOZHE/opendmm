module OpenDMM
  module Maker
    module Baltan
      include Maker

      module Site
        include HTTParty
        base_uri 'baltan-av.com'

        def self.item(name)
          case name
          when /(TMAM|TMCY|TMDI|TMEM|TMVI)-?(\d{3})/i
            get("/items/detail/#{$1.upcase}-#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(Utils.force_utf8(content))
          return {
            actresses:       html.xpath('//*[@id="content1"]/section/div[2]/table/tr[7]/td/a').map(&:text),
            code:            html.xpath('//*[@id="content1"]/section/div[2]/table/tr[1]/td').text,
            cover_image:     html.css('#content1 > section > div.img > img').first['src'],
            description:     html.css('#content1 > section > p').text,
            label:           html.xpath('//*[@id="content1"]/section/div[2]/table/tr[4]/td').text,
            movie_length:    html.xpath('//*[@id="content1"]/section/div[2]/table/tr[2]/td').text,
            page:            page_uri.to_s,
            release_date:    html.xpath('//*[@id="content1"]/section/div[2]/table/tr[3]/td').text,
            series:          html.xpath('//*[@id="content1"]/section/div[2]/table/tr[5]/td').text,
            theme:           html.xpath('//*[@id="content1"]/section/div[2]/table/tr[6]/td').text,
            thumbnail_image: html.css('#content1 > section > div.img > img').first['src'],
            title:           html.css('#content1 > section > h2').text,
          }
        end
      end
    end
  end
end
