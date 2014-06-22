module OpenDMM
  module Maker
    module Aurora
      include Maker

      module Site
        base_uri 'www.aurora-pro.com'

        def self.item(name)
          case name
          when /^(APAA|APAK)-?(\d{3})$/i
            get("/shop/-/product/p/goods_id=#{$1.upcase}-#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css('div#product_info dl'))
          return {
            actresses:       specs['出演女優'].css('ul li').map(&:text),
            actress_types:   specs['女優タイプ'].css('ul li').map(&:text),
            code:            specs['作品番号'].text,
            cover_image:     html.at_css('div.main_pkg a img')['src'],
            description:     html.css('div#product_exp p').text,
            directors:       specs['監督'].css('ul li').map(&:text),
            genres:          specs['ジャンル'].css('ul li').map(&:text),
            label:           specs['レーベル'],
            maker:           'Apache Project',
            movie_length:    specs['収録時間'].text,
            page:            page_uri.to_s,
            release_date:    specs['発売日'].text,
            sample_images:   html.css('div.product_scene ul li img').map { |img| img['src'] },
            thumbnail_image: html.at_css('div.main_pkg a img')['src'],
            scenes:          specs['シーン'].css('ul li').map(&:text),
            title:           html.css('h1.pro_title').text,
          }
        end
      end
    end
  end
end
