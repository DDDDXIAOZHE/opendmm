base_uri 'www.mgstage.com'
cookies(adc: 1, coc: 1)
headers({
  "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36"
})

def self.search_url(name)
  name = name.split(/(?<=[a-z])(?=\d)|[-_\s]/).join(' ')
  "/ppv/list/search/#{CGI::escape(name)}/1/table/date/all/"
end

def self.product_url(name)
  search_page = get_with_retry search_url(name)
  return nil unless search_page
  search_html = Utils.html_in_utf8 search_page
  first_result = search_html.at_css('#Content > ul > li.item_layout_02_price > a')
  first_result['href'] if first_result
end

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.css('div.content_detail_layout_01 > dl.spec_layout'))
  {
    actresses:       specs['出演：'].css('a').map(&:text),
  # actress_types:   Array
  # boobs:           String
  # brand:           String
  # categories:      Array
    code:            parse_code(specs['品番：'].text),
    cover_image:     html.at_css('#EnlargeImage')['href'],
    description:     html.css('#introduction_text > p.introduction').text,
  # directors:       Array
    genres:          specs['ジャンル：'].css('a').map(&:text),
  # label:           String
    maker:           specs['メーカー：'].text,
    movie_length:    specs['収録時間：'].text,
  # page:            String
    release_date:    specs['配信開始日：'].text,
    sample_images:   html.css('div.content_sample_layout_01 > a.sample_image').map { |a| a['href'] },
  # scenes:          Array
    series:          specs['シリーズ名：'].text,
  # subtitle:        String
  # theme:           String
    thumbnail_image: html.at_css('div.content_detail_layout_01 img.enlarge_image')['src'],
    title:           html.css('.title_detail_layout h1').text,
  }
end

def self.parse_code(str)
  str =~ /^\d+(\w+-\d+)$/ ? $1 : str
end
