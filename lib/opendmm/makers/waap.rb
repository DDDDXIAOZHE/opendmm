module OpenDMM
  module Maker
    module Waap
      include Maker

      module Site
        include HTTParty
        base_uri "www.waap.co.jp"

        def self.item(name)
          name_in_url = name.sub(/([A-Z]{3})-(\d{3})/, '\1\2')
          get("/work/item.php?itemcode=#{name_in_url}")
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = parse_specs(html)
          return {
            page:         page_uri.to_s,
            product_id:   specs["品番"],
            title:        html.css("ul#pan_list li").last.text.strip,
            maker:        specs["メーカー"],
            release_date: Date.parse(specs["発売日"]),
            movie_length: ChronicDuration.parse(specs["収録時間"]),
            brand:        specs["ブランド"],
            series:       specs["シリーズ"],
            label:        specs["レーベル"],
            actresses:    Hash.new_with_keys(specs["出演者"].split),
            directors:    parse_directors(specs["監督"]),
            images: {
              cover:   URI.join(page_uri, html.css("ul#title_img_all li.title_img a").first["href"]).to_s,
              samples: html.css("ul.samplepicture_list li a").map { |a| URI.join(page_uri, a["href"]).to_s },
            },
            genres:       specs["ジャンル"].split,
            descriptions: [
              html.css("div#title_cmt_all").first.text.squish,
            ],
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
          return Hash.new if str == "---"
        end
      end

      def self.search(name)
        case name
        when /AIR-\d{3}/
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end
