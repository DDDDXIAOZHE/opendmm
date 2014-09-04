base_uri 'www.dmm.co.jp'

def self.search_url(name, digit_len)
  name = name.split(/(?<=[a-z])(?=\d)|[-_\s]/).map do |token|
    token =~ /^\d+$/ ? token.rjust(digit_len, '0') : token
  end.join
  "/search/=/searchstr=#{CGI::escape(name)}"
end

def self.product_url(name)
  5.downto(3) do |len|
    search_page = get_with_retry search_url(name, len)
    next unless search_page
    search_html = Utils.html_in_utf8 search_page
    first_result = search_html.at_css('#list > li > div > p.tmb > a')
    return first_result['href'] if first_result
  end
  nil
end

def self.product_extra_info(name, url, page, html)
  dmm_id = page.request.last_uri.to_s.split('/').last.split('=').last
  if dmm_id =~ /\d*([a-z]+)0*(\d+)/i
    dmm_id = "#{$1.upcase}-#{$2.rjust(3, '0')}"
  end
  {
    code: dmm_id,
    maker: 'DMM',
  }
end

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.css('//div[@class="page-detail"]/table/tr/td[1]/table/tr').map(&:text))
  {
    actresses:       ( specs['出演者'] || specs['名前'] ).split(/[\s\/]/),
    cover_image:     ( html.at_css('#sample-video > a')['href'] ||
                       html.at_css('#sample-video > img')['src'] ),
    directors:       specs['監督'].split,
    genres:          specs['ジャンル'].split,
    label:           specs['レーベル'],
    maker:           specs['メーカー'],
    movie_length:    specs['収録時間'],
    release_date:    (specs['商品発売日'] || specs['配信開始日']),
    series:          specs['シリーズ'],
    thumbnail_image: html.at_css('#sample-video img')['src'],
    title:           html.css('#title').text,
  }
end
