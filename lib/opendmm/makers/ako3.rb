module OpenDMM
  module Maker
    module Ako3
      include Maker

      module Site
        include HTTParty
        base_uri "www.ako-3.com"

        def self.item(name)
          case name
          when /(AKO)-?(\d{3})/i
            get("/work/item.php?itemcode=#{$1.upcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css("div#spec-area > div.release").map(&:text))
          return {
            actresses: [
              html.css('//*[@id="spec-area"]/div[2]').text,
            ],
            code:          specs["商品番号"],
            cover_image:   html.css("div.jacket a").first["href"],
            description:   html.css("div#caption").text,
            maker:         specs["メーカー"],
            page:          page_uri.to_s,
            release_date:  Date.parse(specs["配信日"]),
            sample_images: html.css("ul.sampleimg li a").map { |a| a["href"] },
            title:         html.css("div.maintitle").text,
          }
        end
      end
    end
  end
end
