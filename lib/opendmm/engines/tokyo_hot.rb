require 'cgi'
require 'opendmm/movie'
require 'opendmm/search'
require 'opendmm/utils/httparty'

module OpenDMM
  module Engine
    module TokyoHot
      def self.search(query)
        case query
        when /Tokyo Hot n(\d{3,4})/i
          query = "n#{$1.rjust(4, '0')}"
        else
          return
        end
        movie = Movie.new(query, Site.list)
        movie.details
      end

      private

      module Site
        include HTTParty
        base_uri 'www.tokyo-hot.com'

        def self.list
          get "/j/new_video0000_j.html"
        end
      end

      class Movie < OpenDMM::Movie
        def initialize(query, response)
          super
          @details.code         = "Tokyo Hot #{query}"
          @details.maker        = 'Tokyo Hot'

          link = @html.at_xpath("//a[contains(@href, '#{@query}')]")
          @details.page         = link['href']
          @details.cover_image  = link.at_css('img')['src']

          table = link.ancestors('table').first
          table.css('br').each do |br|
            br.replace "\n"
          end
          @details.title        = table.at_xpath('tr[1]').text
          @details.actresses    = table.at_xpath('tr[2]').text.squish.remove('--').split(/[\s、,]/)
          @details.release_date = table.at_xpath('tr[3]').text.remove('更新日')
        end
      end
    end
  end
end