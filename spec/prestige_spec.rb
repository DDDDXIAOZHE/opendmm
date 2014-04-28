require 'minitest/autorun'
require 'opendmm'

describe OpenDMM::Prestige do
  it 'supports ABP series' do
    details = OpenDMM::Prestige.search('ABP-013')
    details[:title].must_equal         "天然成分由来 水咲ローラ汁120%＋生写真7枚付き"
    details[:cover_image].must_equal   "http://image.prestige-av.com/images/prestige/abp/013/pb_e_abp-013.jpg"
    details[:actresses].must_equal     [ "水咲(滝澤)ローラ" ]
    details[:movie_length].must_equal  "120min"
    details[:release_date].must_equal  "2013/07/02"
    details[:maker].must_equal         "プレステージ"
    details[:product_id].must_equal    "ABP-013"
    details[:genres].must_equal        [ "通販限定", "潮吹き", "女優", "パイパン" ]
    details[:series].must_equal        "天然成分由来"
    details[:label].must_equal         "ABSOLUTELY P…"
    details[:sample_images].must_equal([
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_0_abp-013.jpg",
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_1_abp-013.jpg",
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_2_abp-013.jpg",
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_3_abp-013.jpg",
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_4_abp-013.jpg",
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_5_abp-013.jpg",
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_6_abp-013.jpg",
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_7_abp-013.jpg",
      "http://image.prestige-av.com/images/prestige/abp/013/cap_e_8_abp-013.jpg"
    ])
    details[:review].must_equal(
      "プレステージ専属女優 『水咲 ローラ』 が熱気を漂わせながら超濃厚なセックスを展開！"\
      "男と相互奉仕の応酬をして、貪るような肉食っぷりを披露！"\
      "焦らされたカラダは手マンされ、カメラが水没するほど何度も大量潮吹き！"\
      "パイパンマ〇コにパワフルな腰使いでピストンされ、本気汁まみれで悶えっぱなし！！"
    )
  end
end