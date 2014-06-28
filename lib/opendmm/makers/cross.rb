base_uri 'crosscross.jp'

register_product(
  /(CRAD|CRPD|CRSS)-?(\d{3})/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('#details > div > dl'))
  {
    actresses:       specs['出演女優'].css('a').map(&:text),
    cover_image:     html.at_css('#pake')['href'],
    description:     html.css('#details > div > p.story').text,
    directors:       specs['監督'].css('a').map(&:text),
    genres:          specs['ジャンル'].css('a').map(&:text),
    maker:           'Cross',
    movie_length:    specs['収録時間'].text,
    release_date:    specs['発売日'].text,
    sample_images:   html.css('#sample-pic > li > a').map { |a| a['href'] },
    series:          specs['シリーズ'].text,
    thumbnail_image: html.at_css('#pake > img')['src'],
    title:           html.css('#details > div > h3').text,
  }
end
