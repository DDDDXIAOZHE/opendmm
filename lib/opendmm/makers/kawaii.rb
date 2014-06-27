module OpenDMM
  module Maker
    module Kawaii
      include Maker

      module Site
        base_uri 'kawaiikawaii.jp'

        def self.item(name)
          case name
          when /^(KAWD)-?(\d{3})$/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css('#content > div.col540 > div > div.dvd_info > dl'))
          return {
            actresses:       specs['出演者'].css('a').map(&:text),
            code:            (specs['DVD品番'] || spesc['Blu-ray品番']).text,
            cover_image:     html.at_css('#content > div.col300 > span.pake > p.textright > a > img')['src'].gsub(/pm.jpg$/, 'pl.jpg'),
            description:     html.css('#content > div.col540 > div > p.text').text,
            genres:          specs['ジャンル'].css('a').map(&:text),
            maker:           'Kawaii',
            movie_length:    (specs['DVD収録時間'] || specs['Blu-ray収録時間']).text,
            page:            page_uri.to_s,
            release_date:    (specs['DVD発売日'] || specs['Blu-ray発売日']).text,
            sample_images:   html.css('#work_image_unit > a > img').map { |img| img['src'].gsub(/js(?=-\d+\.jpg$)/, 'jp') },
            series:          specs['シリーズ'].text,
            title:           html.css('#content > div.col540 > div > h3.worktitle').text,
            thumbnail_image: html.at_css('#content > div.col300 > span.pake > p.textright > a > img')['src'],
          }
        end
      end
    end
  end
end
