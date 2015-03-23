module OpenDMM
  class Search
    def initialize(query, response)
      @query = query
      @response = response
      @html = Nokogiri.HTML @response
    end

    def result
      URI.join(@response.request.last_uri.to_s, @result).to_s
    end
  end
end