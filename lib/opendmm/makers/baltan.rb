base_uri 'baltan-av.com'

register_product(
  /^(TMAM|TMCY|TMDI|TMEM|TMVI)-?(\d{3})$/i,
  '/items/detail/#{$1.upcase}-#{$2}',
)

private

def self.parse_product_html(html)
  {
    actresses:       html.xpath('//*[@id="content1"]/section/div[2]/table/tr[7]/td/a').map(&:text),
    cover_image:     html.at_css('#content1 > section > div.img > img')['src'],
    description:     html.css('#content1 > section > p').text,
    label:           html.xpath('//*[@id="content1"]/section/div[2]/table/tr[4]/td').text,
    maker:           'Baltan',
    movie_length:    html.xpath('//*[@id="content1"]/section/div[2]/table/tr[2]/td').text,
    release_date:    html.xpath('//*[@id="content1"]/section/div[2]/table/tr[3]/td').text,
    series:          html.xpath('//*[@id="content1"]/section/div[2]/table/tr[5]/td').text,
    theme:           html.xpath('//*[@id="content1"]/section/div[2]/table/tr[6]/td').text,
    thumbnail_image: html.at_css('#content1 > section > div.img > img')['src'],
    title:           html.css('#content1 > section > h2').text,
  }
end
