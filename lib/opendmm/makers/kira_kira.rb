module OpenDMM
  module Maker
    module KiraKira
      include Maker

      module Site
        include HTTParty
        base_uri 'kirakira-av.com'

        def self.item(name)
          case name
          when /^(BLK|KIRD|KISD|SET)-?(\d{3})$/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.xpath('//*[@id="wrap-works"]/section/section[2]/dl'))
          return {
            actresses:       specs['出演女優'].css('ul > li').map(&:text),
            code:            specs['品番'].text,
            cover_image:     html.at_css('#slider > ul.slides > li:nth-child(1) > img')['src'],
            description:     html.xpath('//*[@id="wrap-works"]/section/section[1]/p').text,
            genres:          specs['ジャンル'].css('ul > li').map(&:text),
            label:           specs['レーベル'].text,
            movie_length:    specs['収録時間'].text,
            page:            page_uri.to_s,
            release_date:    specs['発売日'].text,
            sample_images:   html.css('#slider > ul.slides > li > img').map { |img| img['src'] }[1..-1],
            thumbnail_image: html.at_css('#carousel > ul.slides > li:nth-child(1) > img')['src'],
            title:           html.css('#wrap-works > section > h1').text,
          }
        end
      end
    end
  end
end
