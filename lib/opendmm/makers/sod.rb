base_uri 'ec.sod.co.jp'

register_product(
  /^(NAGE|SDDE|SDMT|SDMU|SDNM|STAR)-?(\d{3})$/i,
  '/detail/index/-_-/iid/#{$1.upcase}-#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.xpath('//*[@id="main"]/tr/td[2]/table/tr[1]/td[1]/table/tr[1]/td/table/tr/td[2]/table/tr').map(&:text))
  {
    actresses:       specs['出演'].split,
    cover_image:     html.at_xpath('//*[@id="main"]/tr/td[2]/table/tr[1]/td[1]/table/tr[1]/td/table/tr/td[1]/a[1]')['href'],
    description:     html.css('div.detail-datacomment').text,
    directors:       specs['監督'].split,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           specs['メーカー'],
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日'],
    sample_images:   html.css('div.detail-thumb-sample-box > a').map { |a| a['href'] },
    series:          specs['シリーズ'],
    thumbnail_image: html.at_xpath('//*[@id="main"]/tr/td[2]/table/tr[1]/td[1]/table/tr[1]/td/table/tr/td[1]/a[1]/img')['src'],
    title:           html.css('div.title-base > div.title-base-dvd1 > div.title-base-dvd2 > h1').text,
  }
end
