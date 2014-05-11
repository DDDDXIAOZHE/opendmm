module OpenDMM
  module Maker
    module Munekyunkissa
      include Maker

      module Site
        include HTTParty
        base_uri "www.munekyunkissa.com"

        def self.item(name)
          name =~ /(\w+)-(\d+)/
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
            actresses:    Hash.new_with_keys(data_right["出演者"].text.remove("：").split),
            description:  html.css("div.ttl-comment div.comment").first.text.squish,
            images: {
              cover:   URI.join(page_uri, html.css("div.ttl-pac a.ttl-package").first["href"]).to_s,
              samples: html.css("div.ttl-sample img").map { |img| URI.join(page_uri, img["src"]).to_s },
            },
            maker:        "胸キュン喫茶",
            movie_length: ChronicDuration.parse(data_left["収録時間"].text.remove("：").squish),
            page:         page_uri.to_s,
            product_id:   data_left["品番"].text.remove("：").squish,
            release_date: Date.parse(data_left["発売日"].text.remove("：").squish),
            title:        html.css("div.capt01").first.text.squish,
            # TODO: parse series, label, genres from pics
          }
        end
      end

      def self.search(name)
        case name
        when /ALB-\d{3}/i
          Parser.parse(Site.item(name))
        end
      end
    end
  end
end
