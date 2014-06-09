module OpenDMM
  module Maker
    module Aknr
      include Maker

      module Site
        include HTTParty
        base_uri "www.aknr.com"

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
            actresses:     html.xpath('//*[@id="data"]/div[2]/span').map(&:text),
            code:          html.xpath('//*[@id="info2"][2]/div[2]').text,
            cover_image:   html.xpath('//*[@id="jktimg_l2"]/a').first["href"],
            directors:     html.xpath('//*[@id="info2"][1]/div[2]').text.split,
            movie_length:  ChronicDuration.parse(html.xpath('//*[@id="info2"][3]/div[2]').text),
            page:          page_uri.to_s,
            release_date:  Date.parse(html.xpath('//*[@id="data"]/div[2]').text),
            sample_images: html.xpath('//*[@id="photo"]/p/a').map { |a| a["href"] },
            title:         html.css("#mainContent2 > h1").text,
          }
        end
      end
    end
  end
end
