module OpenDMM
  module Maker
    module Apache
      include Maker

      module Site
        include HTTParty
        base_uri "www.apa-av.jp"

        def self.item(name)
          name =~ /AP-(\d+)/
          get("/list_detail/detail_#{$1}.html")
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = parse_specs(html)
          return {
            actresses:     Hash.new_with_keys(specs["出演女優"].split(",")),
            code:          specs["品番"],
            cover_image:   URI.join(page_uri, html.css("div.detail_img a").first["href"]).to_s,
            description:   html.css("div.detail_description").first.inner_text.squish,
            directors:     Hash.new_with_keys(specs["監督"].split),
            maker:         "Apache",
            movie_length:  ChronicDuration.parse(specs["収録時間"]),
            page:          page_uri.to_s,
            sample_images: html.css("ul.detail-main-thum li a").map { |a| URI.join(page_uri, a["href"]).to_s },
            title:         html.css("div.detail_title_1").text.squish,
          }
        end

        private

        def self.parse_specs(html)
          specs = {}
          html.css("ul.detail-main-meta li").each do |li|
            if li.text =~ /(.*)：(.*)/
              specs[$1.squish] = $2.squish
            end
          end
          specs
        end
      end

      def self.search(name)
        case name
        when /AP-\d{3}/i
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end
