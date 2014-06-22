module OpenDMM
  module Maker
    module Apache
      include Maker

      module Site
        base_uri 'www.apa-av.jp'

        def self.item(name)
          case name
          when /^AP-?(\d{3})$/i
            get("/list_detail/detail_#{$1}.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css('ul.detail-main-meta li').map(&:text))
          return {
            actresses:       specs['出演女優'].split(','),
            code:            specs['品番'],
            cover_image:     html.at_css('#right > div.detail-main > div.detail_img > a')['href'],
            description:     html.at_css('#right > div.detail-main > div.detail_description').inner_text,
            directors:       specs['監督'].split,
            maker:           'Apache',
            movie_length:    specs['収録時間'],
            page:            page_uri.to_s,
            sample_images:   html.css('#right > div.detail-main > div.detail_description > ul > li > a').map { |a| a['href'] },
            thumbnail_image: html.at_css('#right > div.detail-main > div.detail_img > a > img')['src'],
            title:           html.css('div.detail_title_1').text,
          }
        end
      end
    end
  end
end
