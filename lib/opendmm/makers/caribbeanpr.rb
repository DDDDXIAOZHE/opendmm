base_uri 'www.caribbeancompr.com'

register_product(
  /^Caribpr ?(\d{6})[-_](\d{3})$/i,
  '/moviepages/#{$1}_#{$2}/index.html',
  'Caribpr #{$1}_#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('div.main-content-movieinfo > div.movie-info > dl').map(&:text))
  {
    actresses:       specs['出演'].split,
  # brand:           String
    categories:      specs['カテゴリー'].split,
    cover_image:     './images/l_l.jpg',
    description:     html.css('div.main-content-movieinfo > div.movie-comment').text,
  # directors:       Array
  # genres:          Array
  # label:           String
    maker:           specs['スタジオ'],
    movie_length:    specs['再生時間'],
    release_date:    specs['配信日'],
    sample_images:   html.css('div.detail-content.detail-content-gallery > ul > li > div > a').map { |a| a['href'] }.reject{ |uri| uri =~ /\/member\// },
  # scenes:          Array
    series:          specs['シリーズ'],
  # subtitle:        String
  # theme:           String
    thumbnail_image: './images/main_b.jpg',
    title:           html.css('div.main-content-movieinfo > div.video-detail > span > h1').text,
  }
end
