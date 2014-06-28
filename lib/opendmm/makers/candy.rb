base_uri 'candy-av.com'

register_product(
  /^(CND)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('#actress > div > dl'))
  {
    actresses:       specs['出演女優'].css('a').map(&:text),
    cover_image:     html.at_xpath('//*[@id="thumbnail"]/a[1]')['href'],
    description:     html.css('#brand > p.p_actress_detail').text,
    genres:          specs['ジャンル'].css('a').map(&:text),
    maker:           'Candy',
    movie_length:    specs['収録時間'].text,
    release_date:    specs['発売日'].text,
    sample_images:   html.css('#brand > div.photo_sumple > ul > li > a').map { |a| a['href'] },
    thumbnail_image: html.at_xpath('//*[@id="thumbnail"]/a[1]/img')['src'],
    series:          specs['シリーズ'].text,
    title:           html.css('#brand > div.m_t_4 > h3').text,
  }
end

def self.parse_code(text)
  return text unless text.include? '⁄'
  text.lines.map do |line|
    line.split '⁄'
  end.squish_hard.to_h['DVD']
end
