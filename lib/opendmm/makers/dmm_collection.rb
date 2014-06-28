base_uri 'dmm-collection.com'

register_product(
  /^(DCOL|DGL)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.xpath('//*[@id="information"]/dl[2]'))
  {
    actresses:       html.css('#information > dl.actress > dd > a').map(&:text),
    cover_image:     html.at_xpath('//*[@id="package"]/h4/a')['href'],
    description:     html.xpath('//*[@id="comment"]/h5').text,
    maker:           'D★Collection',
    movie_length:    specs['収録時間'].text,
    release_date:    specs['DVD発売日'].text,
    sample_images:   html.xpath('//*[@id="photo"]/ul/li/a').map { |a| a['href'] },
    thumbnail_image: html.at_xpath('//*[@id="package"]/h4/a/img')['src'],
    title:           html.xpath('//*[@id="information"]/h3').text,
  }
end
