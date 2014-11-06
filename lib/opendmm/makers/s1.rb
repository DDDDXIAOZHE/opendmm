base_uri 'www.s1s1s1.com'

register_product(
  /^(ONSD|SNIS|SOE|SPS)-?(\d{3})$/i,
  '/works/-/detail/=/cid=#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.xpath('//*[@id="contents"]/dl'))
  {
    actresses:       specs['女優'].text.split,
    cover_image:     html.at_xpath('//*[@id="slide-photo"]/div[@class="slide pake"]/img')['src'],
    description:     html.css('#contents > p.tx-comment').text,
    directors:       specs['監督'].text.split,
    genres:          (specs['ジャンル'].css('a').map(&:text) if specs['ジャンル']),
    maker:           'S1',
    release_date:    specs['発売日'].text,
    sample_images:   html.xpath('//*[@id="slide-photo"]/div[contains(@class, "slide") and not(contains(@class, "pake"))]/img').map { |img| img['src'] },
    series:          specs['シリーズ'].text,
    thumbnail_image: html.at_css('#slide-thumbnail > ul.ts_container > li.ts_thumbnails > div.ts_preview_wrapper > ul.ts_preview > li > img')['src'],
    title:           html.css('#contents > h1').text,
  }
end
