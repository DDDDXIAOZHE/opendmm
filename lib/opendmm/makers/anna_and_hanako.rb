base_uri 'anna-and-hanako.jp'

register_product(
  /^(ANND)-?(\d{3})$/i,
  '/works/#{$1.downcase}/#{$1.downcase}#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.xpath('//*[@id="pake-bottom-box_r"]/dl/p').map(&:text))
  {
    actresses:       specs['出演者'].split('/'),
    cover_image:     html.at_xpath('//*[@id="pake-bottom-box"]/dl/a')['href'],
    description:     html.xpath('//*[@id="txt-bottom-box"]').text,
    directors:       specs['監督'].split('/'),
    maker:           'アンナと花子',
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日'],
    sample_images:   html.xpath('//*[@id="mein-sanpuru-sam"]/a').map { |a| a['href'] },
    thumbnail_image: html.at_xpath('//*[@id="pake-bottom-box"]/dl/a/img')['src'],
    title:           html.xpath('//*[@id="mein-left-new-release-box"]/div/div/h5').text,
  }
end
