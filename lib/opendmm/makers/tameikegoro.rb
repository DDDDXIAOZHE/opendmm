module OpenDMM
  module Maker
    module Tameikegoro
      include Maker

      module Site
        base_uri 'tameikegoro.jp'

        def self.item(name)
          case name
          when /^(MDYD)-?(\d{3})$/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css('#work-detail > h4, p').map(&:text))
          return {
            actresses:       specs['出演女優'].split,
            code:            specs['品番'],
            cover_image:     html.at_css('#work-pake')['src'].gsub(/pm.jpg$/, 'pl.jpg'),
            description:     html.css('#work-detail > h5').text,
            directors:       specs['監督'].split,
            genres:          specs['ジャンル'].split,
            label:           specs['レーベル'],
            maker:           '溜池ゴロー',
            page:            page_uri.to_s,
            release_date:    specs['発売日'].remove('DVD/'),
            sample_images:   html.css('#sample-pic > a > img').map { |img| img['src'].gsub(/js(?=-\d+\.jpg)/, 'jp') },
            series:          specs['シリーズ'],
            thumbnail_image: html.at_css('#work-pake')['src'],
            title:           html.css('#work-detail > h3').text,
          }
        end
      end
    end
  end
end
