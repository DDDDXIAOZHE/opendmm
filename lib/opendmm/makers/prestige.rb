module OpenDMM
  module Maker
    module Prestige
      include Maker

      module Site
        include HTTParty
        base_uri "www.prestige-av.com"
        cookies(adc: 1)

        def self.item(name)
          get("/item/prestige/#{name.upcase}")
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.parse_dl(html.css("div.product_detail_layout_01 dl.spec_layout"))
          descriptions = parse_descriptions(html)
          return {
            actresses:     parse_actresses(specs["出演："]),
            code:          specs["品番："].text.squish,
            cover_image:   html.css("div.product_detail_layout_01 p.package_layout a.sample_image").first["href"],
            description:   [ descriptions["作品情報"].text, descriptions["レビュー"].text ].join.squish,
            genres:        specs["ジャンル："].css("a").map(&:text).map(&:squish),
            # TODO: Parse complete label, for example
            #       "ABSOLUTELY P…" should be "ABSOLUTELY PERFECT"
            label:         specs["レーベル："].text.squish,
            maker:         specs["メーカー名："].text.squish,
            movie_length:  ChronicDuration.parse(specs["収録時間："].text.squish),
            page:          page_uri.to_s,
            release_date:  Date.parse(specs["発売日："].text.squish),
            sample_images: descriptions["サンプル画像"].css("a.sample_image").map { |a| a["href"] },
            series:        specs["シリーズ："].text.squish,
            title:         html.css("div.product_title_layout_01").text.squish,
          }
        end

        private

        def self.parse_descriptions(html)
          layouts = html.css("div.product_layout_01 div.product_description_layout_01")
          titles = layouts.css("h2.title").map(&:text)
          contents = layouts.css(".contents")
          Hash[titles.zip(contents)]
        end

        def self.parse_actresses(node)
          if node.nil?
            nil
          elsif !node.css("a").empty?
            node.css("a").map(&:text).map(&:squish)
          else
            [ node.text.squish ]
          end
        end
      end

      def self.search(name)
        case name
        when /(ABP|ABS|ABY|CHN|CHS|DOM|EDD|ESK|EZD|HAZ|HON|INU|JOB|LLR|MAS|MBD|MDC|MEK|MMY|NDR|NOF|OSR|PPB|PPT|RAW|SAD|SGA|SPC|SRS|TAP|TDT|TRD|WAT|WPC|XND|YRH|YRZ)-\d{3}/i
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end
