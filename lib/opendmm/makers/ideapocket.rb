base_uri 'www.ideapocket.com'

register_product(
  /^(IDBD|IPSD|IPTD|IPZ|SUPD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.xpath('//*[@id="contents-inline"]/dl'))
  {
    actresses:       specs['女優'].css('span,a').map(&:text),
    cover_image:     html.xpath('//*[@id="slide-photo"]/div/img').first['src'],
    directors:       specs['監督'].css('span,a').map(&:text),
    description:     html.xpath('//*[@id="contents-inline"]/p').text,
    genres:          specs['ジャンル'].css('span,a').map(&:text),
    label:           specs['レーベル'].text,
    maker:           'Ideapocket',
    movie_length:    nil,
    release_date:    specs['発売日'].text,
    sample_images:   html.xpath('//*[@id="slide-photo"]/div/img')[1..-1].map { |img| img['src'] },
    thumbnail_image: html.xpath('//*[@id="slide-photo"]/div/img').first['src'],
    series:          specs['シリーズ'].text,
    title:           html.xpath('//*[@id="contents-inline"]/h1').text,
  }
end

