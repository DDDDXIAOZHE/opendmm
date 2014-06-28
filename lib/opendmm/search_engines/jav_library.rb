base_uri 'www.javlibrary.com'

def self.search_url(name)
  "/ja/vl_searchbyid.php?keyword=#{CGI::escape(name)}"
end

def self.product_url(name)
  search_page = get_with_retry search_url(name)
  return nil unless search_page
  if search_page.code == 302
    url = search_page.headers['location']
  else
    search_html = Utils.html_in_utf8 search_page
    first_result = search_html.at_css('#rightcolumn > div.videothumblist > div.videos > div.video > a')
    return nil unless first_result
    url = first_result['href']
  end
  URI.join(search_page.request.last_uri, url).to_s
end

def self.parse_product_html(html)
  {
    actresses:       html.css('#video_cast .text span.cast').map(&:text),
    code:            html.css('#video_id .text').text,
    cover_image:     html.at_css('#video_jacket > a')['href'],
    directors:       html.css('#video_director .text span.director').map(&:text),
    genres:          html.css('#video_genres .text span.genre').map(&:text),
    label:           html.css('#video_label .text').text,
    maker:           html.css('#video_maker .text').text,
    movie_length:    html.css('#video_length .text').text + ' minutes',
    release_date:    html.css('#video_date .text').text,
    thumbnail_image: html.at_css('#video_jacket_img')['src'],
    title:           html.css('#video_title > h3').text.remove(html.css('#video_id .text').text),
  }
end
