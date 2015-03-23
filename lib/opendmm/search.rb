module OpenDMM
  class Search
    def initialize(page, query)
      @page = page
      @query = query
      @html = Nokogiri.HTML @page
    end

    def result
      URI.join(@page.request.last_uri.to_s, @result).to_s
    end
  end
end