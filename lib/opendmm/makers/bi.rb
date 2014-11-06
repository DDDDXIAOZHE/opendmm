base_uri 'www.bi-av.com'

register_product(
  /^(BBI|BEB|BID|BWB)-?(\d{3})$/i,
  '/works/#{$1.downcase}/#{$1.downcase}#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.xpath('//*[@id="content-box"]/div[3]/div[2]/ul/li').map(&:text))
  {
    actresses:       specs['出演女優'].split('/'),
    cover_image:     html.at_xpath('//*[@id="content-box"]/div[3]/div[1]/a')['href'],
    description:     html.xpath('//*[@id="content-box"]/div[3]/div[2]/p').text,
    directors:       specs['監督'].split,
    genres:          specs['ジャンル'].split('/'),
    label:           specs['レーベル'],
    maker:           '美',
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日'],
    sample_images:   html.xpath('//*[@id="content-box"]/div[3]/div[7]/ul/li/a').map { |a| a['href'] },
    thumbnail_image: html.at_xpath('//*[@id="content-box"]/div[3]/div[1]/a/img')['src'],
    series:          specs['シリーズ'],
    subtitle:        html.css('#content-box > p.works-subtl650').text,
    title:           html.xpath('//*[@id="content-box"]/h1').text,
  }
end
