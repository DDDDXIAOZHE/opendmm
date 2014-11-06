base_uri 'www.aurora-pro.com'
cookies(apse: 1)

register_product(
  /^(APAA|APAK)-?(\d{3})$/i,
  '/shop/-/product/p/goods_id=#{$1.upcase}-#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('div#product_info dl'))
  {
    actresses:       specs['出演女優'].css('ul li').map(&:text),
    actress_types:   specs['女優タイプ'].css('ul li').map(&:text),
    cover_image:     html.at_css('div.main_pkg a img')['src'],
    description:     html.css('div#product_exp p').text,
    directors:       specs['監督'].css('ul li').map(&:text),
    genres:          specs['ジャンル'].css('ul li').map(&:text),
    label:           specs['レーベル'],
    maker:           'Aurora Project',
    movie_length:    specs['収録時間'].text,
    release_date:    specs['発売日'].text,
    sample_images:   html.css('div.product_scene ul li img').map { |img| img['src'] },
    thumbnail_image: html.at_css('div.main_pkg a img')['src'],
    scenes:          specs['シーン'].css('ul li').map(&:text),
    title:           html.css('h1.pro_title').text,
  }
end
