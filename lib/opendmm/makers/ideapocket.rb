base_uri 'ideapocket.com'

register_product(
  /^(IDBD|IPSD|IPTD|IPZ|SUPD)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = parse_specs(html)
  {
    actresses:       html.xpath('//*[@id="content-box"]/p[1]').text.split('/'),
    cover_image:     html.at_css('div#content-box div.pake a')['href'],
    directors:       specs['監督'].split,
    description:     html.xpath('//*[@id="content-box"]/p[2]').text,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           'Ideapocket',
    movie_length:    specs['収録時間']['DVD'],
    release_date:    specs['発売日']['DVD'],
    sample_images:   html.css('div#sample-pic a').map { |a| a['href'] },
    thumbnail_image: html.at_css('#content-box > div.pake > a > img')['src'],
    series:          specs['シリーズ'],
    title:           html.css('div#content-box h2.list-ttl').text,
  }
end

def self.parse_specs(html)
  specs = {}
  last_key = nil
  html.xpath('//*[@id="navi-right"]/div[1]/p').text.lines do |line|
    if line =~ /(.*)：(.*)/
      specs[$1.squish] = $2.squish
      last_key = $1.squish
    else
      specs[last_key] += line.squish
    end
  end
  specs.each do |key, value|
    tokens = value.squish.split(/(Blu-ray|DVD)/)
    tokens = tokens.delete_if(&:empty?).map(&:squish)
    case tokens.size
    when 2,4
      specs[key] = Hash[*tokens]
    end
  end
  specs
end
