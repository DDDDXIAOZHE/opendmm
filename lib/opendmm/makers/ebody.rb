base_uri 'www.av-e-body.com'

register_product(
  /^(EBOD)-?(\d{3})$/i,
  '/works/#{$1.downcase}/#{$1.downcase}#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('div.title-data > dl')).merge(
          Utils.hash_by_split(html.xpath('//*[@id="content"]/div/div[3]/div[1]/p').text.lines))
  {
    actresses:       specs['出演女優'].css('a').map(&:text),
    cover_image:     html.at_css('div.package > a.package-pic')["href"],
    description:     html.css('div.title-data > p.comment').text,
    genres:          specs['ジャンル'].css('a').map(&:text),
    maker:           'E-Body',
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日'].text,
    sample_images:   html.css('div.sample-box > ul.sample-pic > li > a').map { |a| a["href"] },
    thumbnail_image: html.at_css('#content > div > div.left-box > div.package > a > img')['src'],
    series:          specs['シリーズ'].text.remove('：'),
    title:           html.css('div.title-data > h1').text,
  }
end
