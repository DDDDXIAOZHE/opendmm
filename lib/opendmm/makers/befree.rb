module OpenDMM
  module Maker
    module Befree
      include Maker

      module Site
        include HTTParty
        base_uri "befreebe.com"

        def self.item(name)
          case name
          when /(BF)-?(\d{3})/i
            get("/works/#{$1.downcase}/#{$1.downcase}#{$2}.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_from_dl(html.css('#right-navi > dl')).merge(
                  Utils.hash_by_split(html.xpath('//*[@id="right-navi"]/div[1]/p[2]').map(&:text)))
          return {
            actresses:     html.css('#content > div.main > section > p.actress > a').map(&:text),
            code:          specs['品番：'].text,
            cover_image:   html.css('#content > div.main > section > div.package > img').first['src'],
            description:   html.css('#content > div.main > section > p.comment').text,
            directors:     specs['監督：'].text.split,
            genres:        specs['ジャンル：'].css('a').map(&:text),
            movie_length:  specs['収録時間'],
            page:          page_uri.to_s,
            release_date:  specs['発売日：'].text,
            sample_images: html.css('#content > div.main > section > ul > li > a').map { |a| a['href'] },
            title:         html.xpath('//*[@id="content"]/div[2]/section/h2[1]').text,
          }
        end
      end
    end
  end
end
