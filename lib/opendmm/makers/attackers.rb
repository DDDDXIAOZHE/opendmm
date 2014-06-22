module OpenDMM
  module Maker
    module Attackers
      include Maker

      module Site
        base_uri 'attackers.net'

        def self.item(name)
          case name
          when /^(ADN|ATID|JBD|RBD|SHKD|SSPD)-?(\d{3})$/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css('div#works-content ul li').map(&:text))
          return {
            actresses:       specs['出演女優'].split,
            code:            parse_code(specs['品番']),
            cover_image:     html.at_css('div#works_pake_box a#pake')['href'],
            directors:       specs['監督'].split,
            description:     html.css('p.works_txt').text,
            genres:          specs['ジャンル'].split,
            label:           specs['レーベル'],
            maker:           'Attackers',
            movie_length:    specs['収録時間'],
            page:            page_uri.to_s,
            release_date:    specs['発売日'],
            sample_images:   html.css('ul#sample_photo li a').map { |a| a['href'] },
            series:          specs['シリーズ'],
            thumbnail_image: html.at_css('#pake > img')['src'],
            title:           html.css('div.hl_box_btm').text,
          }
        end

        private

        def self.parse_code(str)
          case str
          when /Blu-ray：(\w+-\d+).*DVD：(\w+-\d+)/
            $2.upcase
          when /\w+-\d+/
            $&
          end
        end
      end
    end
  end
end
