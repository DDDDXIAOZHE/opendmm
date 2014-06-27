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
          code = page_uri.to_s.split('/').last
          specs = html.xpath('//*[@class="detail"]/article/p[2]').text.split('|')
          return {
            actresses:       parse_actresses(code),
            code:            'S-Cute ' + code,
            cover_image:     parse_cover_image(html, code),
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

        def self.parse_actresses(code)
          case code
          when /^\d{3}[-_](\w+)[-_]\d{2}$/i, /^(?:ps\d|swm)[-_]\d{2}[-_](\w+)$/i
            [ $1.match(/[a-z]+/)[0].humanize ]
          else
            nil
          end
        end

        def self.parse_cover_image(html, code)
          cover_img = html.at_css('#movie > div > div > div > a > img')
          return cover_img['src'] if cover_img
          case code
          when /^(\d{3})[-_](\w+)[-_](\d{2})$/i
            "http://static.s-cute.com/images/#{$1}_#{$2}/#{$1}_#{$2}_#{$3}/#{$1}_#{$2}_#{$3}_sample.jpg"
          else
            nil
          end
        end
      end
    end
  end
end
