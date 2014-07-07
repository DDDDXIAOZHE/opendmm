base_uri 'www.1pondo.tv'

register_product(
  /^1pondo ?(\d{6})[-_](\d{3})$/i,
  '/moviepages/#{$1}_#{$2}/index.html',
  '1pondo #{$1}_#{$2}',
)

private

def self.parse_product_html(html)
  {
    actresses:       html.css('#profile-area > div > ul.bgoose > li > a > h2').map(&:text),
  # brand:           String
  # categories:      Array
  # cover_image:     String
    description:     html.css('#profile-area > div.rr2').inner_text,
  # directors:       Array
  # genres:          Array
  # label:           String
    maker:           '一本道',
  # movie_length:    String
  # release_date:    String
    sample_images:   html.css('#movie-main > div.pics > table > tr > td > img').map { |img| img['src'] },
  # scenes:          Array
  # series:          String
  # subtitle:        String
  # theme:           String
    thumbnail_image: './images/thum_b.jpg',
    title:           parse_title(html.css('head > title').text),
  }
end

def self.parse_title(str)
  str =~ /「(.*)」/ ? $1 : str
end

def self.product_extra_info(name, url, page, html)
  cover_image = URI.join(page.request.last_uri, "./images/str.jpg").to_s
  cover_image = URI.join(page.request.last_uri, "./images/popu.jpg").to_s if get_with_retry(cover_image).code != 200
  {
    cover_image: cover_image
  }
end