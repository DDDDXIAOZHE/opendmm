require "opendmm/prestige/site"
require "nokogiri"
require "opendmm/utils"

module OpenDMM
  module Prestige
    class Parser
      def self.parse(name)
        case name
        when /ABP-\d{3}/, /ABS-\d{3}/, /ABY-\d{3}/
          html = Nokogiri::HTML(Site.new.item(name))
          spec = Utils.parse_dl(html.css("div.product_detail_layout_01 dl.spec_layout"))
          descriptions = self.parse_descriptions(html)
          return {
            title:         html.css("div.product_title_layout_01").first.text.strip,
            cover_image:   html.css("div.product_detail_layout_01 p.package_layout a.sample_image").first["href"],
            actresses:     spec["出演："].css("a").map(&:text).map(&:strip),
            movie_length:  spec["収録時間："].text.strip,
            release_date:  spec["発売日："].text.strip,
            maker:         spec["メーカー名："].text.strip,
            product_id:    spec["品番："].text.strip,
            genres:        spec["ジャンル："].css("a").map(&:text).map(&:strip),
            series:        spec["シリーズ："].text.strip,
            # TODO: Parse complete label, for example
            #       "ABSOLUTELY P…" should be "ABSOLUTELY PERFECT"
            label:         spec["レーベル："].text.strip,
            information:   descriptions["作品情報"].text.strip,
            sample_images: descriptions["サンプル画像"].css("a.sample_image").map { |a| a["href"] },
            review:        descriptions["レビュー"].text.strip
          }
        end
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
      Parser.parse(name)
    end
  end
end