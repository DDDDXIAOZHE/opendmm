base_uri 'www.befreebe.com'

register_product(
  /^(BF)-?(\d{3})$/i,
  '/works/#{$1.downcase}/#{$1.downcase}#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('#right-navi > dl')).merge(
          Utils.hash_by_split(html.xpath('//*[@id="right-navi"]/div[1]/p[2]').map(&:text)))
  {
    actresses:       html.css('#content > div.main > section > p.actress').text.split(/：|\s|\//)[1..-1],
    cover_image:     html.at_css('#content > div.main > section > div.package > img')['src'],
    description:     html.css('#content > div.main > section > p.comment').text,
    directors:       specs['監督：'].text.split,
    genres:          specs['ジャンル：'].css('a').map(&:text),
    maker:           'BeFree',
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日：'].text,
    sample_images:   html.css('#content > div.main > section > ul > li > a').map { |a| a['href'] },
    thumbnail_image: html.at_css('#content > div.main > section > div.package > img')['src'],
    title:           html.xpath('//*[@id="content"]/div[2]/section/h2[1]').text,
  }
end
