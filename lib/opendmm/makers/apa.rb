module OpenDMM
  module Maker
    module Apache
      include Maker

      module Site
        include HTTParty
        base_uri "www.apa-av.jp"

        def self.item(name)
          case name
          when /AP-?(\d{3})/
            get("/list_detail/detail_#{$1}.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css("ul.detail-main-meta li").map(&:text))
          return {
            actresses:     specs["出演女優"].split(","),
            code:          specs["品番"],
            cover_image:   URI.join(page_uri, html.css("div.detail_img a").first["href"]).to_s,
            description:   html.css("div.detail_description").first.inner_text.squish,
            directors:     specs["監督"].split,
            maker:         "Apache",
            movie_length:  ChronicDuration.parse(specs["収録時間"]),
            page:          page_uri.to_s,
            sample_images: html.css("ul.detail-main-thum li a").map { |a| URI.join(page_uri, a["href"]).to_s },
            title:         html.css("div.detail_title_1").text.squish,
          }
        end
      end
    end
  end
end
