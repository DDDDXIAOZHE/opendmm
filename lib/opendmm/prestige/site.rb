require "httparty"

module OpenDMM
  module Prestige
    class Site
      include HTTParty
      base_uri "www.prestige-av.com"
      cookies(adc: 1)

      def item(name)
        self.class.get("/item/prestige/#{name}/")
      end
    end
  end
end