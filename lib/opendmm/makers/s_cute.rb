base_uri 'www.s-cute.com'

register_product(
  /^S[-_]?Cute\s*(\d{3})[-_](\w+)[-_](\d{2})$/i,
  '/contents/#{$1}_#{$2}_#{$3}/',
  'S-Cute #{$1}_#{$2}_#{$3}',
)
register_product(
  /^S[-_]?Cute\s*(ps\d|swm)[-_](\d{2})[-_](\w+)$/i,
  '/contents/#{$1}_#{$2}_#{$3}/',
  'S-Cute #{$1}_#{$2}_#{$3}',
)

private

def self.parse_product_html(html)
  specs = html.xpath('//*[@class="detail"]/article/p[2]').text.split('|')
  details = {
    description:     html.css('//*[@class="detail"]/article/p[4]').text,
    maker:           'S-Cute',
    movie_length:    specs[1],
    release_date:    specs[0],
    sample_images:   html.css('#grid-gallery > div.item > div > a').map { |a| a['href'] },
    thumbnail_image: html.at_css('div.cast > a > img')['src'],
    title:           html.css('div.detail > article > h3').text,
  }
  cover_img = html.at_css('#movie > div > div > div > a > img')
  details[:cover_image] = cover_img['src'] if cover_img
  details
end

def self.product_extra_info(name, url, page, html)
  code = product_code(name)
  extra_info = Hash.new
  if code =~ /(\d{3}_\w+_\d{2})/i
    extra_info[:cover_image] = "http://static.s-cute.com/images/#{$1}_#{$2}/#{$1}_#{$2}_#{$3}/#{$1}_#{$2}_#{$3}_sample.jpg"
  end
  if code =~ /\d{3}_(\w+)_\d{2}/i || code =~ /(?:ps\d|swm)_\d{2}_(\w+)/i
    extra_info[:actresses] = [ $1.match(/[a-z]+/)[0].humanize ]
  end
  extra_info
end

def self.parse_cover_image(html)
  cover_img = html.at_css('#movie > div > div > div > a > img')
  cover_img ? cover_img['src'] : nil
end
