module OpenDMM
  module Maker
    module Premium
      include Maker

      module Site
        include HTTParty
        base_uri 'premium-beauty.com'

        def self.item(name)
          case name
          when /^(PBD|PGD|PJD|PTV|PXD)-?(\d{3})$/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.xpath('//*[@id="sub-navi"]/div[1]/div[1]/table/tr').map(&:text))
          return {
            actresses:       html.css('#content > div > div > div.actress-list > dl > dd > a').map(&:text),
            code:            specs['DVD品番'] || specs['Blu-ray品番'],
            cover_image:     html.at_css('#pake')['href'],
            description:     html.css('#content > div > div > div.detail_text').text,
            directors:       specs['監督'].split,
            genres:          specs['ジャンル'].split('/'),
            label:           specs['レーベル'],
            movie_length:    specs['DVD収録時間'] || specs['Blu-ray収録時間'],
            page:            page_uri.to_s,
            release_date:    specs['発売日'],
            sample_images:   html.css('#sample_photo > li > a').map { |a| a['href'] },
            series:          specs['シリーズ'],
            thumbnail_image: html.at_css('#pake > img')['src'],
            title:           html.css('#content > div > h2').text,
          }
        end
      end
    end
  end
end
