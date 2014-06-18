module OpenDMM
  module Maker
    module Aknr
      include Maker

      module Site
        include HTTParty
        base_uri 'www.aknr.com'

        def self.item(name)
          case name
          when /(FSET)-?(\d{3})/i
            get("/works/#{$1.downcase}-#{$2}/")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          return {
            actresses:       html.css('//*[@id="info"]/div[3]/div[2]').text.split,
            code:            html.css('//*[@id="info"]/div[5]/div[2]').text,
            cover_image:     html.at_css('#jktimg_l2 > a')['href'],
            directors:       html.css('//*[@id="info"]/div[4]/div[2]').text.split,
            movie_length:    html.css('//*[@id="info"]/div[6]/div[2]').text,
            page:            page_uri.to_s,
            release_date:    html.css('//*[@id="info"]/div[2]/div[2]').text,
            sample_images:   html.css('#photo > p > a').map { |a| a['href'] },
            thumbnail_image: html.at_css('#jktimg_l2 > a > img')['src'],
            title:           html.css('#mainContent2 > h1').text,
          }
        end
      end
    end
  end
end
