module OpenDMM
  module Maker
    module Ako3
      include Maker

      module Site
        include HTTParty
        base_uri "www.ako-3.com"

        def self.item(name)
          name =~ /(\w+)-?(\d+)/
          get("/work/item.php?itemcode=#{$1.upcase}#{$2}")
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = parse_specs(html)
          return {
            actresses: [
              specs["title"]
            ],
            code:          specs["商品番号"],
            cover_image:   URI.join(page_uri, html.css("div.jacket a").first["href"]).to_s,
            description:   html.css("div#caption").text.squish,
            maker:         specs["メーカー"],
            page:          page_uri.to_s,
            release_date:  Date.parse(specs["配信日"]),
            sample_images: html.css("ul.sampleimg li a").map { |a| URI.join(page_uri, a["href"]).to_s },
            title:         html.css("div.maintitle").text.squish,
          }
        end

        private

        def self.parse_specs(html)
          spec_area = html.css("div#spec-area").first
          specs = {
            "face"  => spec_area.css("div.face img").first["src"],
            "title" => spec_area.css("div.title").text.squish,
          }
          spec_area.css("div.release").each do |item|
            if item.text =~ /(.*)：(.*)/
              specs[$1.squish] = $2.squish
            end
          end
          specs
        end
      end

      def self.search(name)
        case name
        when /AKO-?\d{3}/i
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end
