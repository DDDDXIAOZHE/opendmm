base_uri 'highscene.jp'

register_product(
  /^(HIGH)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}/',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split html.css('#works-details > dl > dd > p').map(&:text)
  {
    actresses:       [ html.css('#content > h2').text[/(?<=>>).*/] ],
  # brand:           String
  # categories:      Array
    cover_image:     html.at_css('#actimg > li > a')['href'],
    description:     html.css('#works-details > p.works-txt').text,
  # directors:       Array
    genres:          specs['ジャンル'].split('/'),
    label:           specs['レーベル'],
    maker:           'High Scene',
    movie_length:    specs['収録時間'],
    release_date:    specs['配信日'],
    sample_images:   html.css('#actimg > li > a')[1..-1].map { |a| a['href'] },
  # scenes:          Array
  # series:          String
    subtitle:        html.css('#works-details > dl > dt > span').text,
  # theme:           String
    thumbnail_image: html.at_css('#actimg > li > a > img')['src'],
    title:           html.css('#content > h2').text[/(?<=>>).*/],
  }
end
