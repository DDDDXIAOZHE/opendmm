base_uri 'www.tokyo-247.net'

register_product(
  /^Tokyo[-_\s]247\s+?(\w+)$/i,
  '/ms/#{$1.downcase}/contents.php',
  'Tokyo 247 #{$1.downcase}'
)

private

def self.parse_product_html(html)
  {
    actresses:       [ html.css('div.models_head > div.pro_right > div > div.modelname').text ],
  # brand:           String
  # categories:      Array
  # cover_image:     String
    description:     html.css('div.models_head > div.pro_right > div > div:nth-child(3)').text,
  # directors:       Array
  # genres:          Array
  # label:           String
    maker:           'Tokyo 247',
  # movie_length:    String
  # release_date:    String
    sample_images:   html.xpath('/html/body/div[3]/div[1]/div[1]/div[6]').css('div.pict_area > ol > li > a > img').map { |img| img['src'].remove(/s(?=\.jpg$)/) },
  # scenes:          Array
  # series:          String
  # subtitle:        String
  # theme:           String
  # thumbnail_image: String
    title:           html.css('div.models_head > div.pro_right > div > div.modelname').text,
  }
end

def self.product_extra_info(name, url, page, html)
  code = product_code(name)
  code = code[/(?<=Tokyo 247 ).*/]
  extra_info = Hash.new
  extra_info[:thumbnail_image] = "/ms/gallery_parts/#{code}_1.jpg"
  extra_info[:cover_image] = extra_info[:thumbnail_image]
  extra_info
end
