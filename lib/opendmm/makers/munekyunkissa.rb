module OpenDMM
  module Maker
    module Munekyunkissa
      include Maker

      module Site
        base_uri 'www.munekyunkissa.com'

        def self.item(name)
          case name
          when /^(ALB)-?(\d{3})$/i
            get("/works/#{$1.downcase}/#{$1.downcase}#{$2}.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.at_css('dl.data-left')).merge(
                  Utils.hash_from_dl(html.at_css('dl.data-right')))
          return {
            actresses:       specs['出演者'].text.remove('：').split,
            code:            specs['品番'].text.remove('：'),
            cover_image:     html.at_css('div.ttl-pac a.ttl-package')['href'],
            description:     html.css('div.ttl-comment div.comment').text,
            maker:           '胸キュン喫茶',
            movie_length:    specs['収録時間'].text.remove('：'),
            page:            page_uri.to_s,
            release_date:    specs['発売日'].text.remove('：'),
            sample_images:   html.css('div.ttl-sample img').map { |img| img['src'] },
            thumbnail_image: html.at_css('#main > div > div.main-detail > div.ttl-pac > a > img')['src'],
            title:           html.css('div.capt01').text,
            # TODO: parse series, label, genres from pics
          }
        end
      end
    end
  end
end
