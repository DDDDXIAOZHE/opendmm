base_uri 'av-opera.jp'

register_product(
  /^(OPUD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('#container-detail > div.pkg-data > div.data > dl.left-data')).merge(
          Utils.hash_from_dl(html.css('#container-detail > div.pkg-data > div.data > dl.right-data')))
  {
    actresses:       specs['出演女優'].css('a').map(&:text),
    cover_image:     html.at_css('div#container-detail > div.pkg-data > div.pkg > a > img')['src'].gsub(/pm.jpg$/, 'pl.jpg'),
    description:     html.css('#container-detail > div.pkg-data > div.comment-data').text,
    directors:       specs['監督'].css('a').map(&:text),
    genres:          specs['ジャンル'].css('a').map(&:text),
    maker:           'Opera',
    movie_length:    specs['収録時間'].text,
    release_date:    specs['発売日'].text,
    sample_images:   html.css('#sample-pic > li > a > img').map { |img| img['src'].gsub(/js(?=-\d+\.jpg$)/, "jl") },
    scatology:       specs['スカトロ'].css('a').map(&:text),
    series:          specs['シリーズ'].text.remove('：'),
    thumbnail_image: html.at_css('div#container-detail > div.pkg-data > div.pkg > a > img')['src'],
    title:           html.xpath('//*[@id="container-detail"]/p[1]').text,
    transsexual:     specs['ニューハーフ'].css('a').map(&:text),
  }
end
