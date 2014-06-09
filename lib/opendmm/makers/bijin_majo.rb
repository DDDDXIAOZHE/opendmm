module OpenDMM
  module Maker
    module BijinMajo
      include Maker

      module Site
        include HTTParty
        base_uri "bijin-majo-av.com"

        def self.item(name)
          case name
          when /(BIJN)-?(\d{3})/i
            get("/works/#{$1.downcase}/#{$1.downcase}#{$2}.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css('#detail_main > div.detail_item > dl'))
          return {
            actresses:     [ html.css('#detail_main > h2').children.first.text ],
            code:          specs['品番：'].text,
            cover_image:   URI.join(page_uri, html.css('#detail_main > div.figure > a').first['href']).to_s,
            description:   html.css('#detail_main > div.detail_item > p').text,
            movie_length:  ChronicDuration.parse(specs['収録時間：'].text),
            page:          page_uri.to_s,
            release_date:  Date.parse(specs['発売日：'].text),
            sample_images: html.css('#detail_photo > ul > li > a').map { |a| URI.join(page_uri, a['href']).to_s },
            title:         html.css('#detail_main > h2').text,
          }
        end
      end
    end
  end
end
