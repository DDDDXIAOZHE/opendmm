module OpenDMM
  module Maker
    module Aurora
      include Maker

      module Site
        include HTTParty
        base_uri "www.aurora-pro.com"

        def self.item(name)
          get("/shop/-/product/p/goods_id=#{name.upcase}")
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.parse_dl(html.css("div#product_info dl"))
          return {
            actresses:     Hash.new_with_keys(specs["出演女優"].css("ul li").map(&:text)),
            actress_types: specs["女優タイプ"].css("ul li").map(&:text),
            code:          specs["作品番号"].text.squish,
            description:   html.css("div#product_exp p").text.squish,
            directors:     Hash.new_with_keys(specs["監督"].css("ul li").map(&:text)),
            genres:        specs["ジャンル"].css("ul li").map(&:text),
            images: {
              cover:   URI.join(page_uri, html.css("div.main_pkg a img").first["src"]).to_s,
              samples: html.css("div.product_scene ul li img").map { |img| URI.join(page_uri, img["src"]).to_s },
            },
            label:         specs["レーベル"],
            maker:         "Apache Project",
            movie_length:  ChronicDuration.parse(specs["収録時間"]),
            page:          page_uri.to_s,
            release_date:  Date.parse(specs["発売日"]),
            scenes:        specs["シーン"].css("ul li").map(&:text),
            title:         html.css("h1.pro_title").text.squish,
          }
        end
      end

      def self.search(name)
        case name
        when /(APAA|APAK)-\d{3}/i
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end
