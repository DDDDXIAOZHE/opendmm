module OpenDMM
  module Maker
    module Aurora
      include Maker

      module Site
        include HTTParty
        base_uri "www.aurora-pro.com"

        def self.item(name)
          case name
          when /(APAA|APAK)-?(\d{3})/i
            get("/shop/-/product/p/goods_id=#{$1.upcase}-#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.parse_dl(html.css("div#product_info dl"))
          return {
            actresses:     specs["出演女優"].css("ul li").map(&:text),
            actress_types: specs["女優タイプ"].css("ul li").map(&:text),
            code:          specs["作品番号"].text.squish,
            cover_image:   URI.join(page_uri, html.css("div.main_pkg a img").first["src"]).to_s,
            description:   html.css("div#product_exp p").text.squish,
            directors:     specs["監督"].css("ul li").map(&:text),
            genres:        specs["ジャンル"].css("ul li").map(&:text),
            label:         specs["レーベル"],
            maker:         "Apache Project",
            movie_length:  ChronicDuration.parse(specs["収録時間"]),
            page:          page_uri.to_s,
            release_date:  Date.parse(specs["発売日"]),
            sample_images: html.css("div.product_scene ul li img").map { |img| URI.join(page_uri, img["src"]).to_s },
            scenes:        specs["シーン"].css("ul li").map(&:text),
            title:         html.css("h1.pro_title").text.squish,
          }
        end
      end
    end
  end
end
