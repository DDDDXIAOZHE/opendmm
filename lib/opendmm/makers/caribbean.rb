base_uri 'www.caribbeancom.com'

register_product(
  /^Carib ?(\d{6})[-_](\d{3})$/i,
  '/moviepages/#{$1}-#{$2}/index.html',
  'Carib #{$1}-#{$2}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('div.main-content-movieinfo > div.movie-info > dl').map(&:text))
  {
    actresses:       specs['出演'].split,
    categories:      specs['カテゴリー'].split,
    cover_image:     './images/l_l.jpg',
    description:     html.css('div.main-content-movieinfo > div.movie-comment').text,
    maker:           'Caribbean',
    movie_length:    specs['再生時間'],
    release_date:    specs['配信日'],
    sample_images:   html.css('div.detail-content.detail-content-gallery-old > table > tr > td > a').map{ |a| a['href'] }.reject{ |uri| uri =~ /\/member\// },
    thumbnail_image: "./images/l_s.jpg",
    title:           html.css('div.main-content-movieinfo > div.video-detail > span.movie-title > h1').text,
  }
end
