base_uri 'www.ako-3.com'

register_product(
  /^(AKO)-?(\d{3})$/i,
  '/work/item.php?itemcode=#{$1.upcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('div#spec-area > div.release').map(&:text))
  {
    actresses:       [ html.css('//*[@id="spec-area"]/div[2]').text ],
    cover_image:     html.at_css('div.jacket a')['href'],
    description:     html.css('div#caption').text,
    maker:           specs['メーカー'],
    release_date:    specs['配信日'],
    sample_images:   html.css('ul.sampleimg li a').map { |a| a['href'] },
    thumbnail_image: html.at_css('#title-area > div > div.jacket > a > img')['src'],
    title:           html.css('div.maintitle').text,
  }
end
