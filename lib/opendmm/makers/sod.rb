module OpenDMM
  module Maker
    module Sod
      include Maker

      module Site
        include HTTParty
        base_uri 'ec.sod.co.jp'

        def self.item(name)
          case name
          when /(NAGE|SDDE|SDMT|SDMU|SDNM|STAR)-?(\d{3})/i
            get("/detail/index/-_-/iid/#{$1.upcase}-#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.xpath('//*[@id="main"]/tr/td[2]/table/tr[1]/td[1]/table/tr[1]/td/table/tr/td[2]/table/tr').map(&:text))
          return {
            actresses:       specs['出演'].split,
            code:            specs['品番'],
            cover_image:     html.at_xpath('//*[@id="main"]/tr/td[2]/table/tr[1]/td[1]/table/tr[1]/td/table/tr/td[1]/a[1]')['href'],
            description:     html.css('div.detail-datacomment').text,
            directors:       specs['監督'].split,
            genres:          specs['ジャンル'].split,
            label:           specs['レーベル'],
            maker:           specs['メーカー'],
            movie_length:    specs['収録時間'],
            page:            page_uri.to_s,
            release_date:    specs['発売日'],
            sample_images:   html.css('div.detail-thumb-sample-box > a').map { |a| a['href'] },
            series:          specs['シリーズ'],
            thumbnail_image: html.at_xpath('//*[@id="main"]/tr/td[2]/table/tr[1]/td[1]/table/tr[1]/td/table/tr/td[1]/a[1]/img')['src'],
            title:           html.css('div.title-base > div.title-base-dvd1 > div.title-base-dvd2 > h1').text,
          }
        end
      end
    end
  end
end
