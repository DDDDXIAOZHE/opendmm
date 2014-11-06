base_uri 'www.ran-maru.com'

register_product(
  /^(TYOD)-?(\d{3})$/i,
  '/works/#{$1.downcase}/#{$1.downcase}#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = parse_specs(html)
  {
    actresses:       specs['女優名'].split('/'),
    cover_image:     html.at_css('#works > div > div.works-box > div.left-box > dl > dt > a')['href'],
    description:     specs[:description],
    genres:          specs['ジャンル'].split('/'),
    maker:           '乱丸',
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日'],
    thumbnail_image: html.at_css('#works > div > div.works-box > div.left-box > dl > dt > a > img')['src'],
    title:           html.css('#works > div > div.date-unit > h2').text,
  }
end

def self.parse_specs(html)
  root = html.css('#works > div > div.works-box > div.left-box > dl > dd > p')
  groups = root.children.to_a.split do |delimeter|
    delimeter.name == 'br'
  end.map do |group|
    group.map(&:text).join
  end
  Utils.hash_by_split(groups).tap do |specs|
    specs[:description] = groups.last
  end
end
