base_uri 'd-o-c.biz'

register_product(
  /^(CRS|FTN|GDW|INF|LNS|NLF|NRS|RDT|RTP|ULT|VVP|YUM)-?(\d{3})$/i,
  '/catalog/#{$1.downcase}-#{$2}.html',
)

private

def self.parse_product_html(html)
  specs = parse_specs(html)
  {
    actresses:       parse_actresses(specs['女優']),
  # brand:           String
  # categories:      Array
  # code:            String
    cover_image:     html.at_css('#single_box > div.entry-content > img')['src'],
    description:     specs['商品説明'],
  # directors:       Array
    genres:          specs['ジャンル'].split('・'),
    label:           specs['レーベル'],
    maker:           'DOC',
    movie_length:    specs['収録'],
  # page:            String
    release_date:    specs['発売日'],
  # sample_images:   Array
  # scenes:          Array
    series:          specs['シリーズ'],
  # subtitle:        String
  # theme:           String
    thumbnail_image: html.at_css('#single_box > div.entry-content > img')['src'],
    title:           html.css('#single_box > h1').text,
  }
end

def self.parse_actresses(str)
  names = []
  str.split.each do |piece|
    if piece.length <=3 && names.present? && names[-1].length <= 3
      names[-1] += piece
    else
      names << piece
    end
  end
  names
end

def self.parse_specs(html)
  root = html.css('#single_box > div.entry-content > div')
  groups = root.children.to_a.split do |delimeter|
    delimeter.name == 'br'
  end.map do |group|
    group.map(&:text).join
  end
  Utils.hash_by_split(groups)
end
