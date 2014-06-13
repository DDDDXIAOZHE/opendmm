module OpenDMM
  module Maker
    module Ideapocket
      include Maker

      module Site
        include HTTParty
        base_uri 'ideapocket.com'

        def self.item(name)
          case name
          when /(IDBD|IPSD|IPTD|IPZ|SUPD)-?(\d{3})/i
            get("/works/-/detail/=/cid=#{$1.downcase}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = parse_specs(html)
          return {
            actresses:       html.xpath('//*[@id="content-box"]/p[1]/a').map(&:text),
            code:            specs['品番']['DVD'],
            cover_image:     html.css('div#content-box div.pake a').first['href'],
            directors:       specs['監督'].split,
            description:     html.xpath('//*[@id="content-box"]/p[2]').text,
            genres:          specs['ジャンル'].split,
            label:           specs['レーベル'],
            maker:           'Ideapocket',
            movie_length:    specs['収録時間']['DVD'],
            page:            page_uri.to_s,
            release_date:    specs['発売日']['DVD'],
            sample_images:   html.css('div#sample-pic a').map { |a| a['href'] },
            thumbnail_image: html.css('#content-box > div.pake > a > img').first['src'],
            series:          specs['シリーズ'],
            title:           html.css('div#content-box h2.list-ttl').text,
          }.reject do |k, v|
            case v
            when Array, Hash, String
              v.empty?
            when nil
              true
            end
          end
        end

        private

        def self.parse_specs(html)
          specs = {}
          last_key = nil
          html.xpath('//*[@id="navi-right"]/div[1]/p').text.lines do |line|
            if line =~ /(.*)：(.*)/
              specs[$1.squish] = $2.squish
              last_key = $1.squish
            else
              specs[last_key] += line.squish
            end
          end
          specs.each do |key, value|
            tokens = value.squish.split(/(Blu-ray|DVD)/)
            tokens = tokens.delete_if(&:empty?).map(&:squish)
            case tokens.size
            when 2,4
              specs[key] = Hash[*tokens]
            end
          end
          specs
        end
      end
    end
  end
end
