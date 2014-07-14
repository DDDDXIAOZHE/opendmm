base_uri 'www.g-area.org'

register_product(
  /^Perfect[-_\s]G\s+?le_(\w+)$/i,
  '/sample_le/le_#{$1.downcase}/spalc_gallery.php',
  'Perfect-G #{$1.downcase} Dolce'
)

register_product(
  /^Perfect[-_\s]G\s+Docle\s+(\w+)$/i,
  '/sample_le/le_#{$1.downcase}/spalc_gallery.php',
  'Perfect-G #{$1.downcase} Dolce'
)

register_product(
  /^Perfect[-_\s]G\s+(\w+)\s+Docle$/i,
  '/sample_le/le_#{$1.downcase}/spalc_gallery.php',
  'Perfect-G #{$1.downcase} Dolce'
)

register_product(
  /^Perfect[-_\s]G\s+(?!le_)(\w+)$/i,
  '/sample_pg/#{$1.downcase}/spgallery.php',
  'Perfect-G #{$1.downcase}'
)

private

def self.parse_product_html(html)
  {
    actresses:       [ html.css('div.co_ww > div.prof_dat > div.p_name').text[/(?<=-).*(?=-)/] ],
  # brand:           String
  # categories:      Array
    cover_image:     html.at_css('div.co_ww > div.prof_img > div.pro_imb > div.prof_big > div > img').try(:[], 'src'),
    description:     html.css('div.co_ww > div.prof_img > div.prof_cap').text,
  # directors:       Array
  # genres:          Array
  # label:           String
    maker:           'Perfect-G',
    movie_length:    html.css('div.co_ww > div.prof_dat > div.p_mov').text,
  # release_date:    String
    sample_images:   html.css('div.co_ww > div.prof_img > div.pro_imb div.sml_img_w > div.sml_img > img').map { |img| img['src'] },
  # scenes:          Array
  # series:          String
  # subtitle:        String
  # theme:           String
    thumbnail_image: html.at_css('div.co_ww > div.prof_img > div.pro_imb > div.prof_big > div > img').try(:[], 'src'),
    title:           html.css('div.co_ww > div.prof_dat > div.p_name').text[/(?<=-).*(?=-)/],
  }
end

def self.product_extra_info(name, url, page, html)
  code = product_code(name)
  code = code[/(?<=Perfect-G ).*/]
  extra_info = Hash.new
  extra_info[:thumbnail_image] = "/img/main/#{code}_320_180.jpg"
  extra_info[:cover_image] = extra_info[:thumbnail_image]
  extra_info
end
