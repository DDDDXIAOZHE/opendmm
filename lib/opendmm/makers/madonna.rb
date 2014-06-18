module OpenDMM
  module Maker
    module Madonna
      include Maker

      module Site
        include HTTParty
        base_uri 'madonna-av.com'

        def self.item(name)
          case name
          when /(JUC|JUFD|JUX|OBA|URE)-?(\d{3})/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css('#column_contents > div > div.right_contents > dl'))
          return {
            actresses:       specs['出演女優'].text.split,
            code:            specs['品番'].text.remove('DVD'),
            cover_image:     html.at_css('#column_contents > div > div.left_contents > div.pack > a')['href'],
            description:     html.css('#column_contents > div > div.left_contents > p').text,
            directors:       specs['監督'].text.split,
            genres:          specs['ジャンル'].text.split,
            movie_length:    specs['収録時間'].text.remove('DVD'),
            page:            page_uri.to_s,
            release_date:    specs['発売日'].text.remove('DVD'),
            sample_images:   html.css('#column_contents > div > div.left_contents > div.photo > ul > li > a').map { |a| a['href'] },
            thumbnail_image: html.at_css('#column_contents > div > div.left_contents > div.pack > a > img')['src'],
            title:           html.css('#column_contents > h2').text,
          }
        end
      end
    end
  end
end
