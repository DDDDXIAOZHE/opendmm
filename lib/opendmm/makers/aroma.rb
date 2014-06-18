module OpenDMM
  module Maker
    module Aroma
      include Maker

      module Site
        include HTTParty
        base_uri 'www.aroma-p.com'

        def self.item(name)
          case name
          when /\bARM-?(\d{3})/i
            return get("/member/contents/title.php?conid=101#{$1}")
          when /\bARMG-?(\d{3})/i
            return get("/member/contents/title.php?conid=200#{$1}")
          when /\bPARM-?(\d{3})/i
            return get("/member/contents/title.php?conid=205#{$1}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(Utils.force_utf8(content))
          specs = Utils.hash_by_split(html.xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[2]/td[2]/table/tr/td[3]/table/tr[3]').text.split)
          return {
            actresses:       specs['出演者'].try(:split, '・'),
            code:            specs['品番'],
            cover_image:     parse_cover_image(html, page_uri),
            directors:       specs['監督'].try(:split, '・'),
            description:     html.xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[9]/td[2]').text,
            genres:          specs['ジャンル'].split,
            label:           specs['レーベル'],
            maker:           'Aroma',
            movie_length:    specs['時間'],
            page:            page_uri.to_s,
            sample_images:   parse_sample_images(html, page_uri),
            thumbnail_image: html.at_xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[2]/td[2]/table/tr/td[1]/a/img')['src'],
            title:           html.xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[2]/td[2]/table/tr/td[3]/table/tr[1]/td').text,
          }
        end

        private

        def self.parse_cover_image(html, page_uri)
          href = html.at_xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[2]/td[2]/table/tr/td[1]/a')['href']
          if href =~ /'(\/images\/.*)'/
            return $1
          end
        end

        def self.parse_sample_images(html, page_uri)
          html.xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[7]/td[2]/table/tr[3]').css('td input').map do |input|
            if input['onclick'] =~ /'(\/images\/.*)'/
              $1
            end
          end
        end
      end
    end
  end
end
