module OpenDMM
  module Maker
    module ToSatsu
      include Maker

      module Site
        base_uri 'to-satsu.com'

        def self.item(name)
          case name
          when /^(CLUB)-?(\d{3})$/i
            get("/works/#{$1.downcase}/#{$1.downcase}#{$2}/#{$1.downcase}#{$2}.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css('#main > div > div.main-detail > div.ttl-data > dl'))
          return {
            code:            specs['品番：'].text,
            cover_image:     html.at_css('#main > div > div.main-detail > div.ttl-pac > a')['href'],
            description:     html.xpath('//*[@id="main"]/div/div[@class="main-detail"]/div[@class="ttl-comment"]/div[not(@class)]').text,
            genres:          specs['ジャンル：'].text,
            maker:           '変態紳士倶楽部',
            movie_length:    specs['収録時間：'].text,
            page:            page_uri.to_s,
            release_date:    specs['発売日：'].text,
            sample_images:   html.css('#main > div > div.main-detail > div.ttl-sample > img').map { |img| img['src'] },
            series:          specs['シリーズ：'].text,
            thumbnail_image: html.at_css('#main > div > div.main-detail > div.ttl-pac > a > img')['src'],
            title:           html.css('#main > div > div.capt2').text,
          }
        end
      end
    end
  end
end
