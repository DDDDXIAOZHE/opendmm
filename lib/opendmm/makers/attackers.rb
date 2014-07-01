base_uri 'attackers.net'

register_product(
  /^(ADN|ATID|JBD|RBD|SHKD|SSPD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('div#works-content ul li').map(&:text))
  {
    actresses:       specs['出演女優'].split,
    cover_image:     html.at_css('div#works_pake_box a#pake')['href'],
    description:     html.css('p.works_txt').text,
    directors:       specs['監督'].split,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           'Attackers',
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日'],
    sample_images:   html.css('ul#sample_photo li a').map { |a| a['href'] },
    series:          specs['シリーズ'],
    thumbnail_image: html.at_css('#pake > img')['src'],
    title:           html.css('div.hl_box_btm').text,
  }
end

def self.parse_code(str)
  case str
  when /Blu-ray：(\w+-\d+).*DVD：(\w+-\d+)/
    $2.upcase
  when /\w+-\d+/
    $&
  end
end
