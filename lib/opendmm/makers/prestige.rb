require "httparty"
require "nokogiri"
require "opendmm/utils"

module OpenDMM
  module Maker
    module Prestige
      include Maker

      module Site
        include HTTParty
        base_uri "www.prestige-av.com"
        cookies(adc: 1)

        def self.item(name)
          get("/item/prestige/#{name}")
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          spec = Utils.parse_dl(html.css("div.product_detail_layout_01 dl.spec_layout"))
          descriptions = parse_descriptions(html)
          return {
            page:         page_uri.to_s,
            product_id:   spec["品番："].text.strip,
            title:        html.css("div.product_title_layout_01").first.text.strip,
            maker:        spec["メーカー名："].text.strip,
            release_date: spec["発売日："].text.strip,
            movie_length: spec["収録時間："].text.strip,
            series:       spec["シリーズ："].text.strip,
            # TODO: Parse complete label, for example
            #       "ABSOLUTELY P…" should be "ABSOLUTELY PERFECT"
            label:        spec["レーベル："].text.strip,
            actresses:    Hash.new.tap { |hash| spec["出演："].css("a").each { |link| hash[link.text.strip] =nil } },
            images: {
              cover:   html.css("div.product_detail_layout_01 p.package_layout a.sample_image").first["href"],
              samples: descriptions["サンプル画像"].css("a.sample_image").map { |a| a["href"] },
            },
            genres:       spec["ジャンル："].css("a").map(&:text).map(&:strip),
            descriptions: [
              descriptions["作品情報"].text.strip,
              descriptions["レビュー"].text.strip,
            ],
          }
        end

        private

        def self.parse_descriptions(html)
          layouts = html.css("div.product_layout_01 div.product_description_layout_01")
          titles = layouts.css("h2.title").map(&:text)
          contents = layouts.css(".contents")
          Hash[titles.zip(contents)]
        end
      end

      def self.search(name)
        case name
        when /ABP-\d{3}/, /ABS-\d{3}/, /ABY-\d{3}/
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end