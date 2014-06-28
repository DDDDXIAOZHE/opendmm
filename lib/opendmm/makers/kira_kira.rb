base_uri 'kirakira-av.com'

register_product(
  /^(BLK|KIRD|KISD|SET)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.xpath('//*[@id="wrap-works"]/section/section[2]/dl'))
  {
    actresses:       specs['出演女優'].css('ul > li').map(&:text),
    cover_image:     html.at_css('#slider > ul.slides > li:nth-child(1) > img')['src'],
    description:     html.xpath('//*[@id="wrap-works"]/section/section[1]/p').text,
    genres:          specs['ジャンル'].css('ul > li').map(&:text),
    label:           specs['レーベル'].text,
    maker:           'Kira☆Kira',
    movie_length:    specs['収録時間'].text,
    release_date:    specs['発売日'].text,
    sample_images:   html.css('#slider > ul.slides > li > img').map { |img| img['src'] }[1..-1],
    thumbnail_image: html.at_css('#carousel > ul.slides > li:nth-child(1) > img')['src'],
    title:           html.css('#wrap-works > section > h1').text,
  }
end
