base_uri 'dip-av.jp'

register_product(
  /^(NPS|PTS|WA|ZEX)-?(\d{3})$/i,
  '/detail.php?hinban=#{$1.upcase}-#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('#main > div.detail > div.actor').map(&:text)).merge(
          Utils.hash_by_split(html.xpath('//*[@id="main"]/div[@class="detail"]/div[not(@class)]').text.lines))
  {
    actresses:       specs['出演者'].split,
    cover_image:     html.at_css('#main > div.detail > a')['href'],
    description:     html.css('#main > div.detail > div.comment').text,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           specs['メーカー'],
    movie_length:    specs['収録時間'],
    release_date:    specs['品番'],
    series:          specs['シリーズ'],
    thumbnail_image: html.at_css('#main > div.detail > a > img')['src'],
    title:           html.css('#main > h1').text,
  }
end
