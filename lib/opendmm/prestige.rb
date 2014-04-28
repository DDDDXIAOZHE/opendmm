require 'httparty'
require 'nokogiri'
require 'opendmm/utils'

module OpenDMM
  module Prestige
    class Site
      include HTTParty
      base_uri 'www.prestige-av.com'
      cookies(adc: 1)

      def item(name)
        self.class.get("/item/prestige/#{name}/")
      end
    end

    @@site = Site.new

    def self.search(name)
      case name
      when /ABP-\d{3}/
        html = Nokogiri::HTML(@@site.item(name))
        spec = Utils.dl(html.css('div.product_detail_layout_01 dl.spec_layout'))
        descriptions = self.extract_descriptions(html)
        return {
          title:         html.css('div.product_title_layout_01').first.text.strip,
          cover_image:   html.css('div.product_detail_layout_01 p.package_layout a.sample_image').first['href'],
          actresses:     spec['出演：'].css('a').map(&:text).map(&:strip),
          movie_length:  spec['収録時間：'].text.strip,
          release_date:  spec['発売日：'].text.strip,
          maker:         spec['メーカー名：'].text.strip,
          product_id:    spec['品番：'].text.strip,
          genres:        spec['ジャンル：'].css('a').map(&:text).map(&:strip),
          series:        spec['シリーズ：'].text.strip,
          # TODO:  parse complete label, for example
          #       "ABSOLUTELY P…" should be "ABSOLUTELY PERFECT"
          label:         spec['レーベル：'].text.strip,
          sample_images: descriptions['サンプル画像'].css('a.sample_image').map { |a| a['href'] },
          review:        descriptions['レビュー'].text.strip,
        }
      end
    end

    private

    def self.extract_descriptions(html)
      layouts = html.css('div.product_layout_01 div.product_description_layout_01')
      titles = layouts.css('h2.title').map(&:text)
      contents = layouts.css('.contents')
      Hash[titles.zip(contents)]
    end
  end
end