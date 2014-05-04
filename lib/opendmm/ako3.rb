require "httparty"
require "nokogiri"
require "opendmm/utils"

module OpenDMM
  module Ako3
    module Site
      include HTTParty
      base_uri "www.ako-3.com"
      cookies(adc: 1)

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
          title:         html.css("div.maintitle").first.text.strip_unicode,
          cover_image:   URI.join(page_uri, html.css("div.jacket a").first["href"]).to_s,
          actresses:     {
            specs["title"] => {
              face_image: URI.join(page_uri, specs["face"]).to_s,
              age:        specs["年齢"],
              height:     specs["身長"],
              size:       specs["サイズ"],
            }
          },
          maker:         specs["メーカー"],
          product_id:    specs["商品番号"],
          release_date:  specs["配信日"],
          information:   html.css("div#caption").first.text.strip,
          sample_images: html.css("ul.sampleimg li a").map { |a|
            URI.join(page_uri, a["href"]).to_s
          },
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