base_uri 'www.dmm.co.jp'

def self.search_url(name)
  name = name.split(/(?<=[a-z])(?=\d)|[-_\s]/).map do |token|
    token =~ /^\d{1,4}$/ ? sprintf("%05d", token.to_i) : token
  end.join(' ')
  "/search/=/searchstr=#{CGI::escape(name)}"
end

def self.product_url(name)
  search_page = get_with_retry search_url(name)
  return nil unless search_page
  search_html = Utils.html_in_utf8 search_page
  first_result = search_html.at_css('#list > li > div > p.tmb > a')
  first_result['href'] if first_result
end

def self.product_extra_info(name, url, page, html)
  dmm_id = page.request.last_uri.to_s.split('/').last.split('=').last
  if dmm_id =~ /\d*([a-z]+)0*(\d+)/i
    dmm_id = "#{$1.upcase}-#{$2.rjust(3, '0')}"
  end
  { code: dmm_id }
end

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('//*[@id="mu"]/div/table/tr/td[1]/table/tr').map(&:text))
  {
    actresses:       specs['出演者'].split,
    cover_image:     html.at_css('#sample-video > a')['href'],
    directors:       specs['監督'].split,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           specs['メーカー'],
    movie_length:    specs['収録時間'],
    release_date:    specs['商品発売日'],
    series:          specs['シリーズ'],
    thumbnail_image: html.at_css('#sample-video > a > img')['src'],
    title:           html.css('#title').text,
  }
end
