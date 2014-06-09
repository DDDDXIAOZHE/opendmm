module OpenDMM
  module Maker
    module Munekyunkissa
      include Maker

      module Site
        include HTTParty
        base_uri "www.munekyunkissa.com"

        def self.item(name)
          case name
          when /(ALB)-?(\d{3})/i
            get("/works/#{$1.downcase}/#{$1.downcase}#{$2}.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css("dl.data-left").first).merge(
                  Utils.hash_from_dl(html.css("dl.data-right").first))
          return {
            actresses:     specs["出演者"].text.remove("：").split,
            code:          specs["品番"].text.remove("："),
            cover_image:   URI.join(page_uri, html.css("div.ttl-pac a.ttl-package").first["href"]).to_s,
            description:   html.css("div.ttl-comment div.comment").text,
            maker:         "胸キュン喫茶",
            movie_length:  ChronicDuration.parse(specs["収録時間"].text.remove("：")),
            page:          page_uri.to_s,
            release_date:  Date.parse(specs["発売日"].text.remove("：")),
            sample_images: html.css("div.ttl-sample img").map { |img| URI.join(page_uri, img["src"]).to_s },
            title:         html.css("div.capt01").text,
            # TODO: parse series, label, genres from pics
          }
        end
      end
    end
  end
end
