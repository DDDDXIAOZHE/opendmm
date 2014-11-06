base_uri 'www.kawaiikawaii.jp'

register_product(
  /^(KAWD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('#content > div.col540 > div > div.dvd_info > dl'))
  {
    actresses:       specs['出演者'].text.split('/'),
    cover_image:     html.at_css('#content > div.col300 > span.pake > p.textright > a > img')['src'].gsub(/pm.jpg$/, 'pl.jpg'),
    description:     html.css('#content > div.col540 > div > p.text').text,
    genres:          specs['ジャンル'].text.split('/'),
    maker:           'Kawaii',
    movie_length:    (specs['DVD収録時間'] || specs['Blu-ray収録時間']).text,
    release_date:    (specs['DVD発売日'] || specs['Blu-ray発売日']).text,
    sample_images:   html.css('#work_image_unit > a > img').map { |img| img['src'].gsub(/js(?=-\d+\.jpg$)/, 'jp') },
    series:          specs['シリーズ'].text,
    title:           html.css('#content > div.col540 > div > h3.worktitle').text,
    thumbnail_image: html.at_css('#content > div.col300 > span.pake > p.textright > a > img')['src'],
  }
end
