module OpenDMM
  module Maker
    module Opera
      include Maker

      module Site
        include HTTParty
        base_uri "av-opera.jp"

        def self.item(name)
          case name
          when /(OPUD)-?(\d{3})/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(Utils.force_utf8(content))
          specs = Utils.hash_from_dl(html.css('#container-detail > div.pkg-data > div.data > dl.left-data')).merge(
                  Utils.hash_from_dl(html.css('#container-detail > div.pkg-data > div.data > dl.right-data')))
          return {
            actresses:     specs['出演女優'].css('a').map(&:text),
            code:          specs['DVD品番'].text,
            cover_image:   URI.join(page_uri, html.css('div#container-detail > div.pkg-data > div.pkg > a > img').first['src'].gsub(/pm.jpg$/, 'pl.jpg')).to_s,
            description:   html.css('#container-detail > div.pkg-data > div.comment-data').text,
            directors:     specs['監督'].css('a').map(&:text),
            genres:        specs['ジャンル'].css('a').map(&:text),
            movie_length:  ChronicDuration.parse(specs['収録時間'].text),
            page:          page_uri.to_s,
            release_date:  Date.parse(specs['発売日']),
            sample_images: html.css('#sample-pic > li > a > img').map { |img| URI.join(page_uri, img['src'].gsub(/js(?=-\d+\.jpg$)/, "jl")).to_s },
            series:        specs['シリーズ'].text.remove('：'),
            title:         html.xpath('//*[@id="container-detail"]/p[1]').text,
            __extra: {
              transsexual: specs['ニューハーフ'].css('a').map(&:text),
              scatology:   specs['スカトロ'].css('a').map(&:text),
            },
          }
        end
      end
    end
  end
end
