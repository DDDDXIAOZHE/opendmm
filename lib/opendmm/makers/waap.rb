base_uri 'www.waap.co.jp'

register_product(
  /^(AIR|CEN|CWM|ECB|WDI|WSS)-?(\d{3})$/i,
  '/work/item.php?itemcode=#{$1.upcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('ul.title_shosai li.wkact_ser_maker02').map(&:text))
  {
    actresses:       specs['出演者'].split,
    brand:           specs['ブランド'],
    cover_image:     html.at_css('ul#title_img_all li.title_img a')['href'],
    description:     html.css('div#title_cmt_all').text,
    directors:       specs['監督'].split,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           specs['メーカー'],
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日'],
    sample_images:   html.css('ul.samplepicture_list li a').map { |a| a['href'] },
    series:          specs['シリーズ'],
    thumbnail_image: html.at_css('#title_img_all > li.title_img > a > img')['src'],
    title:           html.css('ul#pan_list li').last.text,
  }
end
