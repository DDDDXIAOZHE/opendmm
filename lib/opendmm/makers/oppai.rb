module OpenDMM
  module Maker
    module Oppai
      include Maker

      module Site
        base_uri 'oppai-av.com'

        def self.item(name)
          case name
          when /^(PPPD|PPSD)-?(\d{3})$/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = parse_specs(html)
          return {
            actresses:       html.css('#content_main_detail > div > div.works_left > p.detail-actress > a').map(&:text),
            boobs:           specs['おっぱい'].text,
            code:            dvd(specs['品番'].text),
            cover_image:     html.at_css('#pake > dt > a')['href'],
            description:     html.css('#content_main_detail > div > div.works_left > p.detail_txt').text,
            genres:          specs['ジャンル'].css('a').map(&:text),
            label:           specs['レーベル'].text,
            movie_length:    dvd(specs['収録時間'].text),
            page:            page_uri.to_s,
            release_date:    dvd(specs['発売日'].text),
            sample_images:   html.css('#sample-pic > div > a').map { |a| a['href'] },
            series:          specs['シリーズ'].text,
            thumbnail_image: html.at_css('#pake > dt > a > img')['src'],
            title:           html.css('#works-name').text,
          }
        end

        private

        def self.parse_specs(html)
          html.css('#content_main_detail > div > div.works_right > ul > li').map do |li|
            [ li.css('span.detail-capt').text,
              li.css('span.detail-data')]
          end.to_h
        end

        def self.dvd(text)
          codes = Utils.hash_by_split(text.lines, '…')
          codes['DVD']
        end
      end
    end
  end
end
