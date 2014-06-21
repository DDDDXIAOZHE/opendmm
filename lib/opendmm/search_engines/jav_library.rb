require 'opendmm/utils'

module OpenDMM
  module SearchEngine
    module JavLibrary
      module Site
        include HTTParty
        base_uri 'www.javlibrary.com'
        follow_redirects false

        def self.search(name)
          get("/ja/vl_searchbyid.php?keyword=#{name}")
        end

        def self.item(id)
          get("/ja/?v=#{id}")
        end
      end

      module Parser
        def self.parse_search_result(content)
          html = Nokogiri::HTML(content)
          first_result = html.css('#rightcolumn > div.videothumblist > div.videos > div.video > a').first
          first_result['href'].remove('./?v=') if first_result
        end

        def self.parse_item(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          return {
            actresses:       html.css('#video_cast .text span.cast').map(&:text),
            code:            html.css('#video_id .text').text,
            cover_image:     html.at_css('#video_jacket > a')['href'],
            directors:       html.css('#video_director .text span.director').map(&:text),
            genres:          html.css('#video_genres .text span.genre').map(&:text),
            label:           html.css('#video_label .text').text,
            maker:           html.css('#video_maker .text').text,
            movie_length:    html.css('#video_length .text').text + ' minutes',
            page:            page_uri.to_s,
            release_date:    html.css('#video_date .text').text,
            thumbnail_image: html.at_css('#video_jacket_img')['src'],
            title:           html.css('#video_title > h3').text.remove(html.css('#video_id .text').text),
          }
        end
      end

      def self.search(name)
        search_result = Site.search(name)
        if search_result.code == 302
          jav_id = search_result.headers['location'].remove('./?v=')
        else
          jav_id = Parser.parse_search_result(search_result)
        end
        Parser.parse_item(Site.item(jav_id)) if jav_id
      end
    end
  end
end