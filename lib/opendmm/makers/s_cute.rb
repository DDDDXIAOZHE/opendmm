module OpenDMM
  module Maker
    module SCute
      include Maker

      module Site
        include HTTParty
        base_uri 'www.s-cute.com'

        def self.item(name)
          case name
          when /^S[-_]?Cute\s*(\d{3}[-_]\w+[-_]\d{2})$/i, /^S[-_]?Cute\s*((ps\d|swm)[-_]\d{2}[-_]\w+)$/i
            get("/contents/#{$1}/")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = html.xpath('//*[@class="detail"]/article/p[2]').text.split('|')
          return {
            code:            'S-Cute ' + page_uri.to_s.split('/').last,
            cover_image:     html.at_css('#movie > div > div > div > a > img')['src'],
            description:     html.css('//*[@class="detail"]/article/p[4]').text,
            maker:           'S-Cute',
            movie_length:    specs[1],
            page:            page_uri.to_s,
            release_date:    specs[0],
            sample_images:   html.css('#grid-gallery > div.item > div > a').map { |a| a['href'] },
            thumbnail_image: html.at_css('div.cast > a > img')['src'],
            title:           html.css('div.detail > article > h3').text,
          }
        end
      end
    end
  end
end
