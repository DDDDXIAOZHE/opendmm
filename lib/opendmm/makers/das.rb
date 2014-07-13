base_uri 'dasdas.jp'

register_product(
  /^(AVOP|DASD|DAZD|PLA)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}/',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl html.css('#container > main > section > section > div.data > dl')
  {
    actresses:       specs['出演者：'].text.split('/'),
  # brand:           String
  # categories:      Array
    cover_image:     html.at_css('div.jacketImage > h1 > a')['href'],
    description:     html.xpath('//*[@id="container"]/main/section/section/p[1]').text,
    directors:       specs['監督者：'].text.split('/'),
  # genres:          Array
  # label:           String
    maker:           'ダスッ！',
    movie_length:    specs['収録時間：'].text,
    release_date:    specs['発売日：'].text,
  # sample_images:   Array
  # scenes:          Array
    series:          specs['シリーズ：'].text,
  # subtitle:        String
  # theme:           String
    thumbnail_image: html.at_css('div.jacketImage > h1 > a > img')['src'],
    title:           html.css('#container > main > section > h1').text,
  }
end
