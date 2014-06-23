require 'opendmm/utils'

module OpenDMM
  module SearchEngine
    module Dmm
      module Site
        include HTTParty
        base_uri 'www.dmm.co.jp'
        follow_redirects false

        def self.search(name)
          name = name.split(/[-_\s]/).map do |token|
            token =~ /\d{1,4}/ ? sprintf("%05d", token.to_i) : token
          end.join(' ')
          get("/search/=/searchstr=#{CGI::escape(name)}")
        end

        def self.get(uri)
          super(uri)
        rescue Errno::ETIMEDOUT => e
          tries ||= 0
          tries++
          tries <= 5 ? retry : raise
        end
      end

      module Parser
        def self.parse_search_result(content)
          html = Nokogiri::HTML(content)
          first_result = html.css('#list > li > div > p.tmb > a').first
          first_result['href'] if first_result
        end

        def self.parse_item(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.css('//*[@id="mu"]/div/table/tr/td[1]/table/tr').map(&:text))
          return {
            actresses:       specs['出演者'].split,
            code:            specs['品番'],
            cover_image:     html.at_css('#sample-video > a')['href'],
            directors:       specs['監督'].split,
            genres:          specs['ジャンル'].split,
            label:           specs['レーベル'],
            maker:           specs['メーカー'],
            movie_length:    specs['収録時間'],
            page:            page_uri.to_s,
            release_date:    specs['商品発売日'],
            series:          specs['シリーズ'],
            thumbnail_image: html.at_css('#sample-video > a > img')['src'],
            title:           html.css('#title').text,
          }
        end
      end

      def self.search(name)
        search_result = Site.search(name)
        item_uri = Parser.parse_search_result(search_result)
        Parser.parse_item(Site.get(item_uri)) if item_uri
      end
    end
  end
end