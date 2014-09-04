base_uri 'tameikegoro.jp'

register_product(
  /^(MDYD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('div.wrap-maincontents > section.wrap-information > div.wrap-detail > div.wrap-detail-text > dl.wrap-detail-item'))
  {
    actresses:       specs['出演女優'].text.split('/'),
    cover_image:     html.css('#wrap-detail-slider > ul.bx-detail-slider > li > img').first['src'],
    description:     html.css('div.wrap-maincontents > section.wrap-information > div.wrap-detail > div.wrap-detail-text > div.wrap-detail-description').text,
    genres:          specs['ジャンル'].text.split,
    maker:           '溜池ゴロー',
    release_date:    specs['発売日'].text,
    series:          specs['シリーズ'].text,
    sample_images:   html.css('#wrap-detail-slider > ul.bx-detail-slider > li > img')[1..-1].map { |img| img['src'] },
    thumbnail_image: html.css('#wrap-detail-slider > ul.bx-detail-slider > li > img').first['src'],
    title:           html.css('div.wrap-maincontents > section.wrap-information > div.bx-index > h2').text,
  }
end
