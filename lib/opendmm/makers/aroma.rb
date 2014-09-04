base_uri 'www.aroma-p.com'

register_product(
  /^(ARM)-?(\d{3})$/i,
  '/member/contents/title.php?conid=101#{$2}',
)
register_product(
  /^(ARMG)-?(\d{3})$/i,
  '/member/contents/title.php?conid=200#{$2}',
)
register_product(
  /^(PARM)-?(\d{3})$/i,
  '/member/contents/title.php?conid=205#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[2]/td[2]/table/tr/td[3]/table/tr[3]').text.split)
  {
    actresses:       specs['出演者'].split('・'),
    cover_image:     parse_cover_image(html),
    directors:       specs['監督'].split('・'),
    description:     html.xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[9]/td[2]').text,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           'Aroma',
    movie_length:    specs['時間'],
    sample_images:   parse_sample_images(html),
    thumbnail_image: html.at_xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[2]/td[2]/table/tr/td[1]/a/img')['src'],
    title:           html.xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[2]/td[2]/table/tr/td[3]/table/tr[1]/td').text,
  }
end

def self.parse_cover_image(html)
  href = html.at_xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[2]/td[2]/table/tr/td[1]/a')['href']
  if href =~ /'(\/images\/.*?)'/
    return $1
  end
end

def self.parse_sample_images(html)
  html.xpath('/html/body/table/tr/td/table/tr[4]/td[2]/table/tr/td[2]/table/tr[3]/td/table/tr[7]/td[2]/table/tr[3]').css('td input').map do |input|
    if input['onclick'] =~ /'(\/images\/.*?)'/
      $1
    end
  end
end
