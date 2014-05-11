module OpenDMM
  module Maker
    module Waap
      include Maker

      module Site
        include HTTParty
        base_uri "www.waap.co.jp"

        def self.item(name)
          name =~ /(\w+)-(\d+)/
          get("/work/item.php?itemcode=#{$1.upcase}#{$2}")
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = parse_specs(html)
          return {
            actresses:    Hash.new_with_keys(specs["出演者"].split),
            brand:        specs["ブランド"],
            description:  html.css("div#title_cmt_all").first.text.squish,
            directors:    parse_directors(specs["監督"]),
            genres:       specs["ジャンル"].split,
            images: {
              cover:   URI.join(page_uri, html.css("ul#title_img_all li.title_img a").first["href"]).to_s,
              samples: html.css("ul.samplepicture_list li a").map { |a| URI.join(page_uri, a["href"]).to_s },
            },
            label:        specs["レーベル"],
            maker:        specs["メーカー"],
            movie_length: ChronicDuration.parse(specs["収録時間"]),
            page:         page_uri.to_s,
            product_id:   specs["品番"],
            release_date: Date.parse(specs["発売日"]),
            series:       specs["シリーズ"],
            title:        html.css("ul#pan_list li").last.text.squish,
          }
        end

        private

        def self.parse_specs(html)
          specs = {}
          html.css("ul.title_shosai li.wkact_ser_maker02").each do |li|
            if li.text =~ /(.*)：(.*)/
              specs[$1.squish] = $2.squish
            end
          end
          specs
        end

        def self.parse_directors(str)
          return nil if str == "---"
        end
      end

      def self.search(name)
        case name
        when /AIR-\d{3}/i
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end
