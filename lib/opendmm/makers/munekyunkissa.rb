base_uri 'www.munekyunkissa.com'

register_product(
  /^(ALB)-?(\d{3})$/i,
  '/works/#{$1.downcase}/#{$1.downcase}#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = Utils.hash_from_dl(html.at_css('dl.data-left')).merge(
          Utils.hash_from_dl(html.at_css('dl.data-right')))
  {
    actresses:       specs['出演者'].text.remove('：').split('/'),
    cover_image:     html.at_css('div.ttl-pac a.ttl-package')['href'],
    description:     html.css('div.ttl-comment div.comment').text,
    maker:           '胸キュン喫茶',
    movie_length:    specs['収録時間'].text.remove('：'),
    release_date:    specs['発売日'].text.remove('：'),
    sample_images:   html.css('div.ttl-sample img').map { |img| img['src'] },
    thumbnail_image: html.at_css('#main > div > div.main-detail > div.ttl-pac > a > img')['src'],
    title:           html.css('div.capt01').text,
    # TODO: parse series, label, genres from pics
  }
end
