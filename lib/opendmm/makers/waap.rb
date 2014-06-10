module OpenDMM
  module Maker
    module Waap
      include Maker

      module Site
        include HTTParty
        base_uri "www.waap.co.jp"

        def self.item(name)
          name =~ /(\w+)-?(\d+)/
          case name
          when /(AIR|CWM|ECB|WSS)-?(\d{3})/i
            get("/work/item.php?itemcode=#{$1.upcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css("ul.title_shosai li.wkact_ser_maker02").map(&:text))
          return {
            actresses:     specs["出演者"].split,
            brand:         specs["ブランド"],
            code:          specs["品番"],
            cover_image:   html.css("ul#title_img_all li.title_img a").first["href"],
            description:   html.css("div#title_cmt_all").text,
            directors:     specs["監督"],
            genres:        specs["ジャンル"].split,
            label:         specs["レーベル"],
            maker:         specs["メーカー"],
            movie_length:  ChronicDuration.parse(specs["収録時間"]),
            page:          page_uri.to_s,
            release_date:  Date.parse(specs["発売日"]),
            sample_images: html.css("ul.samplepicture_list li a").map { |a| a["href"] },
            series:        specs["シリーズ"],
            title:         html.css("ul#pan_list li").last.text,
          }
        end
      end
    end
  end
end
