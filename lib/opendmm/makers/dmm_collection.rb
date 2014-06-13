module OpenDMM
  module Maker
    module DmmCollection
      include Maker

      module Site
        include HTTParty
        base_uri "dmm-collection.com"

        def self.item(name)
          case name
          when /(DCOL|DGL)-?(\d{3})/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.xpath('//*[@id="information"]/dl[2]'))
          return {
            actresses:       html.css('#information > dl.actress > dd > a').map(&:text),
            code:            specs['品番'].text,
            cover_image:     html.xpath('//*[@id="package"]/h4/a').first['href'],
            description:     html.xpath('//*[@id="comment"]/h5').text,
            movie_length:    specs['収録時間'].text,
            page:            page_uri.to_s,
            release_date:    specs['DVD発売日'].text,
            sample_images:   html.xpath('//*[@id="photo"]/ul/li/a').map { |a| a['href'] },
            thumbnail_image: html.xpath('//*[@id="package"]/h4/a/img').first['src'],
            title:           html.xpath('//*[@id="information"]/h3').text,
          }
        end
      end
    end
  end
end
