base_uri 'www.premium-beauty.com'

register_product(
  /^(PBD|PGD|PJD|PTV|PXD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('#contents > div.bx-information > dl'))
  {
    actresses:       specs['女優'].css('span,a').map(&:text),
    cover_image:     html.at_css('#slider > ul > li > img')['src'],
    description:     html.css('#contents > div.bx-information > p').text,
    genres:          specs['ジャンル'].css('span,a').map(&:text),
    label:           specs['レーベル'].text,
    maker:           'Premium',
    movie_length:    specs['収録時間'].at_css('span').text,
    release_date:    specs['発売日'].text,
    sample_images:   html.css('#slider > ul > li > img')[1..-1].map { |img| img['src'] },
    series:          specs['シリーズ'].text,
    thumbnail_image: html.at_css('#slider > ul > li > img')['src'],
    title:           html.css('#capt-works').text,
  }
end
