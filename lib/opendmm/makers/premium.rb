base_uri 'premium-beauty.com'

register_product(
  /^(PBD|PGD|PJD|PTV|PXD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.xpath('//*[@id="sub-navi"]/div[1]/div[1]/table/tr').map(&:text))
  {
    actresses:       html.css('#content > div > div > div.actress-list > dl > dd > a').map(&:text),
    cover_image:     html.at_css('#pake')['href'],
    description:     html.css('#content > div > div > div.detail_text').text,
    directors:       specs['監督'].split,
    genres:          specs['ジャンル'].split('/'),
    label:           specs['レーベル'],
    maker:           'Premium',
    movie_length:    specs['DVD収録時間'] || specs['Blu-ray収録時間'],
    release_date:    specs['発売日'],
    sample_images:   html.css('#sample_photo > li > a').map { |a| a['href'] },
    series:          specs['シリーズ'],
    thumbnail_image: html.at_css('#pake > img')['src'],
    title:           html.css('#content > div > h2').text,
  }
end
