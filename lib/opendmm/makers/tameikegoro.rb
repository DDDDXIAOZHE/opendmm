base_uri 'tameikegoro.jp'

register_product(
  /^(MDYD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('#work-detail > h4, p').map(&:text))
  {
    actresses:       specs['出演女優'].split,
    cover_image:     html.at_css('#work-pake')['src'].gsub(/pm.jpg$/, 'pl.jpg'),
    description:     html.css('#work-detail > h5').text,
    directors:       specs['監督'].split,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           '溜池ゴロー',
    release_date:    specs['発売日'].remove('DVD/'),
    sample_images:   html.css('#sample-pic > a > img').map { |img| img['src'].gsub(/js(?=-\d+\.jpg)/, 'jp') },
    series:          specs['シリーズ'],
    thumbnail_image: html.at_css('#work-pake')['src'],
    title:           html.css('#work-detail > h3').text,
  }
end
