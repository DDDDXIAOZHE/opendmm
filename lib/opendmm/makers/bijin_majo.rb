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
            cover_image:   html.css('#detail_main > div.figure > a').first['href'],
            description:   html.css('#detail_main > div.detail_item > p').text,
            movie_length:  specs['収録時間：'].text,
            page:          page_uri.to_s,
            release_date:  specs['発売日：'].text,
            sample_images: html.css('#detail_photo > ul > li > a').map { |a| a['href'] },
            title:         html.css('#detail_main > h2').text,
          }
        end
      end
    end
  end
end
