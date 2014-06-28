base_uri 'www.apa-av.jp'

register_product(
  /^(AP)-?(\d{3})$/i,
  '/list_detail/detail_#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('ul.detail-main-meta li').map(&:text))
  {
    actresses:       specs['出演女優'].split(','),
    cover_image:     html.at_css('#right > div.detail-main > div.detail_img > a')['href'],
    description:     html.at_css('#right > div.detail-main > div.detail_description').inner_text,
    directors:       specs['監督'].split,
    maker:           'Apache',
    movie_length:    specs['収録時間'],
    sample_images:   html.css('#right > div.detail-main > div.detail_description > ul > li > a').map { |a| a['href'] },
    thumbnail_image: html.at_css('#right > div.detail-main > div.detail_img > a > img')['src'],
    title:           html.css('div.detail_title_1').text,
  }
end
