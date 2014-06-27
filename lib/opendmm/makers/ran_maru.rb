module OpenDMM
  module Maker
    module RanMaru
      include Maker

      module Site
        include HTTParty
        base_uri 'ran-maru.com'

        def self.item(name)
          case name
          when /^(TYOD)-?(\d{3})$/i
            get("/works/#{$1.downcase}/#{$1.downcase}#{$2}.html")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = parse_specs(html)
          return {
            actresses:       specs['女優名'].split('/'),
            code:            specs['品番'],
            cover_image:     html.at_css('#works > div > div.works-box > div.left-box > dl > dt > a')['href'],
            description:     specs[:description],
            genres:          specs['ジャンル'].split('/'),
            maker:           '乱丸',
            movie_length:    specs['収録時間'],
            page:            page_uri.to_s,
            release_date:    specs['発売日'],
            thumbnail_image: html.at_css('#works > div > div.works-box > div.left-box > dl > dt > a > img')['src'],
            title:           html.css('#works > div > div.date-unit > h2').text,
          }
        end

      private
        def self.parse_specs(html)
          root = html.css('#works > div > div.works-box > div.left-box > dl > dd > p')
          groups = root.children.to_a.split do |delimeter|
            delimeter.name == 'br'
          end.map do |group|
            group.map(&:text).join
          end
          Utils.hash_by_split(groups).tap do |specs|
            specs[:description] = groups.last
          end
        end
      end
    end
  end
end
