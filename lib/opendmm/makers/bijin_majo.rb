base_uri 'bijin-majo-av.com'

register_product(
  /^(BIJN)-?(\d{3})$/i,
  '/works/#{$1.downcase}/#{$1.downcase}#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('#detail_main > div.detail_item > dl'))
  {
    actresses:       [ html.css('#detail_main > h2').children.first.text ],
    cover_image:     html.at_css('#detail_main > div.figure > a')['href'],
    description:     html.css('#detail_main > div.detail_item > p').text,
    maker:           '美人魔女',
    movie_length:    specs['収録時間：'].text,
    release_date:    specs['発売日：'].text,
    sample_images:   html.css('#detail_photo > ul > li > a').map { |a| a['href'] },
    thumbnail_image: html.at_css('#detail_main > div.figure > a > img')['src'],
    title:           html.css('#detail_main > h2').text,
  }
end
