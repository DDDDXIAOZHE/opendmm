base_uri 'www.10musume.com'

register_product(
  /^10musume ?(\d{6})[-_](\d{2})$/i,
  '/moviepages/#{$1}_#{$2}/index.html',
  '10musume #{$1}_#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.xpath('//*[@id="info"]/div[1]/ul/li').map(&:text))
  {
    actresses:       specs['名前'].split,
  # brand:           String
    categories:      specs['カテゴリー'].split,
    cover_image:     './images/str.jpg',
  # description:     String
  # directors:       Array
  # genres:          Array
  # label:           String
    maker:           '10musume',
    movie_length:    specs['時間'],
    release_date:    specs['更新日'],
    sample_images:   html.css('table#gallery a').map { |a| a['href'] },
  # scenes:          Array
  # series:          String
  # subtitle:        String
  # theme:           String
    thumbnail_image: './images/list1.jpg',
    title:           specs['タイトル'],
  }
end
