module OpenDMM
  module Maker
    module Munekyunkissa
      include Maker

      module Site
        include HTTParty
        base_uri "www.munekyunkissa.com"

        def self.item(name)
          name =~ /([A-Z]{3})-(\d{3})/
          get("/works/#{$1.downcase}/#{$1.downcase}#{$2}.html")
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          data_left = Utils.parse_dl(html.css("dl.data-left").first)
          data_right = Utils.parse_dl(html.css("dl.data-right").first)
          return {
            page:         page_uri.to_s,
            product_id:   data_left["品番"].text.remove("：").squish,
            title:        html.css("div.capt01").first.text.squish,
            maker:        "胸キュン喫茶",
            release_date: Date.parse(data_left["発売日"].text.remove("：").squish),
            movie_length: ChronicDuration.parse(data_left["収録時間"].text.remove("：").squish),
            brand:        nil,
            # TODO: parse series, label, genres from pics
            series:       nil,
            label:        nil,
            actresses:    Hash.new_with_keys(data_right["出演者"].text.remove("：").split),
            directors:    nil,
            images: {
              cover:   URI.join(page_uri, html.css("div.ttl-pac a.ttl-package").first["href"]).to_s,
              samples: html.css("div.ttl-sample img").map { |img| URI.join(page_uri, img["src"]).to_s },
            },
            genres:       nil,
            descriptions: [
              html.css("div.ttl-comment div.comment").first.text.squish,
            ],
          }
        end
      end

      def self.search(name)
        case name
        when /ALB-\d{3}/
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end
