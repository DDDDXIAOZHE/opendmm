base_uri 'www.oppai-av.com'

register_product(
  /^(PPPD|PPSD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = parse_specs(html)
  {
    actresses:       html.css('#content_main_detail > div > div.works_left > p.detail-actress > a').map(&:text),
    boobs:           specs['おっぱい'].text,
    cover_image:     html.at_css('#pake > dt > a')['href'],
    description:     html.css('#content_main_detail > div > div.works_left > p.detail_txt').text,
    genres:          specs['ジャンル'].css('a').map(&:text),
    label:           specs['レーベル'].text,
    maker:           'Oppai',
    movie_length:    dvd(specs['収録時間'].text),
    release_date:    dvd(specs['発売日'].text),
    sample_images:   html.css('#sample-pic > div > a').map { |a| a['href'] },
    series:          specs['シリーズ'].text,
    thumbnail_image: html.at_css('#pake > dt > a > img')['src'],
    title:           html.css('#works-name').text,
  }
end

def self.parse_specs(html)
  html.css('#content_main_detail > div > div.works_right > ul > li').map do |li|
    [ li.css('span.detail-capt').text,
      li.css('span.detail-data')]
  end.to_h
end

def self.dvd(text)
  codes = Utils.hash_by_split(text.lines, '…')
  codes['DVD']
end
