base_uri 'moodyz.com'

def self.product_url(name)
  case name
  when /^(MIAD|MIDD|MIDE|MIGD|MIMK|MINT|MIQD|MIRD|MIXS)-?(\d{3})$/i
    alpha = $1.downcase
    alpha.remove!(/d$/) if ( (alpha == 'midd' && $2.to_i <= 643) ||
                             (alpha == 'migd' && $2.to_i <= 336) ||
                             (alpha == 'mird' && $2.to_i <= 72) )
    "/shop/-/detail/=/cid=#{alpha}#{$2}"
  else
    nil
  end
end

def self.product_code(name)
  case name
  when /^(MIAD|MIDD|MIDE|MIGD|MIMK|MINT|MIQD|MIRD|MIXS)-?(\d{3})$/i
    "#{$1.upcase}-#{$2}"
  else
    nil
  end
end

private

def self.parse_product_html(html)
  specs = Utils.hash_by_split(html.xpath('//*[@id="nabi_information"]/ul/li[1]/dl/dd').map(&:text)).merge(
          Utils.hash_by_split(html.xpath('//*[@id="nabi_information"]/ul/li').map(&:text)[1..-1]))
  {
    actresses:       html.xpath('//*[@id="works"]/dl/dt').map(&:text),
    cover_image:     html.at_xpath('//*[@id="works"]/span/a/p/img')['src'].gsub(/pm.jpg$/, 'pl.jpg'),
    description:     html.xpath('//*[@id="works"]/dl/dd').text,
    directors:       specs['▪監督'].split,
    genres:          specs['▪ジャンル'].split('/'),
    label:           specs['▪レーベル'],
    maker:           'Moodyz',
    movie_length:    specs['収録時間'],
    release_date:    specs['発売日'],
    sample_images:   html.xpath('//*[@id="sample-pic"]/li/a/img').map { |img| img['src'].gsub(/js(?=-\d+\.jpg$)/, 'jp') },
    series:          specs['▪シリーズ'],
    thumbnail_image: html.at_xpath('//*[@id="works"]/span/a/p/img')['src'],
    title:           html.xpath('//*[@id="main"]/ul[2]/h3/dl/dd/h2').text,
  }
end
