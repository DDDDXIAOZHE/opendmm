base_uri 'www.xxx-av.com'

register_product(
  /^XXX ?(\d{4,5})$/i,
  '/mov/view/#{$1}.html',
  'XXX #{$1}',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('#movie > div.movie_bg > div > div.detail > dl'))
  {
    actresses:       html.css('#site_contents > div.right_contents > div.main > div.movie_data > dl > dt').text.split,
  # brand:           String
    categories:      specs['カテゴリ:'].text.split,
  # cover_image:     String
    description:     html.css('#site_contents > div.right_contents > div.main > div.movie_data > dl > dd').text,
  # directors:       Array
    genres:          specs['ジャンル:'].text.split,
    keywords:        specs['キーワード:'].text.split,
  # label:           String
    maker:           'XXX',
    movie_length:    specs['再生時間:'].text,
    release_date:    specs['公開日:'].text,
  # sample_images:   Array
  # scenes:          Array
  # series:          String
  # subtitle:        String
  # theme:           String
  # thumbnail_image: String
    title:           html.css('#movie > div.movie_tt > h2').text,
  }
end

def self.product_extra_info(name, url, page, html)
  code = product_code(name)
  code = code[/(?<=XXX ).*/]
  extra_info = Hash.new
  extra_info[:cover_image] = "http://image.xxx-av.com/image/#{code}/movie_main.jpg"
  extra_info[:thumbnail_image] = "http://image.xxx-av.com/image/#{code}/m_act.jpg"
  extra_info
end
