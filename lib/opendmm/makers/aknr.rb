base_uri 'www.aknr.com'

register_product(
  /^(FSET)-?(\d{3})$/i,
  '/works/#{$1.downcase}-#{$2}/',
)

private

def self.parse_product_html(html)
  {
    actresses:       html.css('//*[@id="info"]/div[3]/div[2]').text.split,
    cover_image:     html.at_css('#jktimg_l2 > a')['href'],
    directors:       html.css('//*[@id="info"]/div[4]/div[2]').text.split,
    maker:           'AKNR',
    movie_length:    html.css('//*[@id="info"]/div[6]/div[2]').text,
    release_date:    html.css('//*[@id="info"]/div[2]/div[2]').text,
    sample_images:   html.css('#photo > p > a').map { |a| a['href'] },
    thumbnail_image: html.at_css('#jktimg_l2 > a > img')['src'],
    title:           html.css('#mainContent2 > h1').text,
  }
end
