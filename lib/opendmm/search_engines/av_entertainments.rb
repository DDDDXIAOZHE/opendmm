base_uri 'www.aventertainments.com'
headers({
  "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36"
})

def self.search_url(name)
  name = name.split(/(?<=[a-z])(?=\d)|[-_\s]/).join('-')
  "/search_Products.aspx?keyword=#{CGI::escape(name)}"
end

def self.product_url(name)
  search_page = get_with_retry search_url(name)
  return nil unless search_page
  search_html = Utils.html_in_utf8 search_page
  first_result = search_html.at_css('div.main-unit2 > table a')
  first_result['href'] if first_result
end

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.xpath('//*[@id="TabbedPanels1"]/div/div[2]/div[1]//ol').text.split('|')).merge(
          Utils.hash_by_split(html.xpath('//*[@id="titlebox"]/ul[3]/li').map(&:text)))
  {
    actresses:       specs['主演女優'].split(','),
  # brand:           String
    categories:      html.xpath('//*[@id="TabbedPanels1"]/div/div[2]/div[2]//ol').map(&:text),
    code:            specs['商品番号'],
    cover_image:     html.at_css('#titlebox > div.list-cover > img')['src'].gsub('jacket_images', 'bigcover'),
    description:     html.css('#titlebox > div.border > p').text,
  # directors:       Array
  # genres:          Array
  # label:           String
    maker:           specs['スタジオ'],
    movie_length:    specs['収録時間'],
  # page:            String
    release_date:    Date.strptime(specs['発売日'], '%m/%d/%Y'),
  # sample_images:   Array
  # scenes:          Array
    series:          specs['シリーズ'],
  # subtitle:        String
  # theme:           String
    thumbnail_image: html.at_css('#titlebox > div.list-cover > img')['src'],
    title:           html.css('#mini-tabet > h2').text,
  }
end
