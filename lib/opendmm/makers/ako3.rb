require "httparty"
require "nokogiri"
require "opendmm/utils"
require "active_support/core_ext/string/filters"

module OpenDMM
  module Maker
    module Ako3
      include Maker

      module Site
        include HTTParty
        base_uri "www.ako-3.com"

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
            product_id:   specs["商品番号"],
            title:        html.css("div.maintitle").first.text.squish,
            maker:        specs["メーカー"],
            release_date: specs["配信日"],
            actresses: {
              specs["title"] => {
                face:   URI.join(page_uri, specs["face"]).to_s,
                age:    specs["年齢"],
                height: specs["身長"],
                size:   specs["サイズ"],
              }
            },
            images: {
              cover:   URI.join(page_uri, html.css("div.jacket a").first["href"]).to_s,
              samples: html.css("ul.sampleimg li a").map { |a| URI.join(page_uri, a["href"]).to_s },
            },
            descriptions: [
              html.css("div#caption").first.text.strip,
            ],
          }
        end

        private

        def self.parse_specs(html)
          spec_area = html.css("div#spec-area").first
          specs = {
            "face"  => spec_area.css("div.face img").first["src"],
            "title" => spec_area.css("div.title").first.text.strip,
          }
          spec_area.css("div.release").each do |item|
            if item.text =~ /(.*)：(.*)/
              specs[$1.strip] = $2.strip
            end
          end
          specs
        end
      end

      def self.search(name)
        case name
        when /AKO-\d{3}/
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end