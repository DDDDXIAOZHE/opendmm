require "minitest/autorun"
require "opendmm"

describe OpenDMM::Prestige do
  it "supports ABP series" do
    details = OpenDMM::Prestige.search("ABP-013")
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
    details[:information].must_equal   "通販限定商品！生写真7枚付きの特典商品です。本数限定となりますのでお早めにお求め下さい！！"
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

  it "supports ABS series" do
    details = OpenDMM::Prestige.search("ABS-014")
    details[:title].must_equal         "貸し切り、純潔サロン04"
    details[:cover_image].must_equal   "http://image.prestige-av.com/images/prestige/abs/014/pb_e_abs-014.jpg"
    details[:actresses].must_equal     [ "絵色 千佳" ]
    details[:movie_length].must_equal  "120min"
    details[:release_date].must_equal  "2011/02/08"
    details[:maker].must_equal         "プレステージ"
    details[:product_id].must_equal    "ABS-014"
    details[:genres].must_equal        [ "潮吹き", "女優", "中出し" ]
    details[:series].must_equal        "貸し切り、純潔サロン"
    details[:label].must_equal         "ABSOLUTE"
    details[:information].must_equal(
      "お嬢様系の超美少女が登場。"\
      "イラマチオ気味にフェラさせられたチ○コをマ○コに突き挿され快感にウットリ。"\
      "中出しされピンク色のマ○コから精子を垂らしピクピク痙攣も見逃せない。"\
      "男の大きな足をゆっくりと舐め出し、ネットリとした舌使いで激エロ奉仕。"\
      "四つん這いやチングリ返しになった男の尻を目を閉じて舐めるシーンもエロ過ぎ！"\
      "学生服姿で肛門丸見えにさせられたり潮吹きもエロい！"\
      "３Ｐになりバックから美尻をプルンプルン波打たせながら打ち込まれ本番になり、角度を変えてピストンされ発射は口へ。"\
      "連続でハメられ２度目も口に掛けられお掃除"
    )
    details[:sample_images].must_equal([
      "http://image.prestige-av.com/images/prestige/abs/014/cap_e_0_abs-014.jpg",
      "http://image.prestige-av.com/images/prestige/abs/014/cap_e_1_abs-014.jpg",
      "http://image.prestige-av.com/images/prestige/abs/014/cap_e_2_abs-014.jpg",
      "http://image.prestige-av.com/images/prestige/abs/014/cap_e_3_abs-014.jpg",
      "http://image.prestige-av.com/images/prestige/abs/014/cap_e_4_abs-014.jpg",
      "http://image.prestige-av.com/images/prestige/abs/014/cap_e_5_abs-014.jpg",
      "http://image.prestige-av.com/images/prestige/abs/014/cap_e_6_abs-014.jpg",
      "http://image.prestige-av.com/images/prestige/abs/014/cap_e_7_abs-014.jpg"
    ])
    details[:review].must_equal        ""
  end

  it "supports ABY series" do
    details = OpenDMM::Prestige.search("ABY-003")
    details[:title].must_equal         "人妻不倫温泉 03＋未公開映像DVD付き(未公開のドライブシーンを収録したDVD付き！)"
    details[:cover_image].must_equal   "http://image.prestige-av.com/images/prestige/aby/003/pb_e_aby-003.jpg"
    details[:actresses].must_equal     [ "真咲 華" ]
    details[:movie_length].must_equal  "120min"
    details[:release_date].must_equal  "2011/05/11"
    details[:maker].must_equal         "プレステージ"
    details[:product_id].must_equal    "ABY-003"
    details[:genres].must_equal        [ "玩具責め", "ハメ撮り", "人妻" ]
    details[:series].must_equal        "人妻不倫温泉"
    details[:label].must_equal         "油屋"
    details[:information].must_equal(
      "欲求不満な顔で男と湖畔をデートする若妻。"\
      "熱いキスを交わしたら駐車場に停めた車内でフェラ抜き。"\
      "旅館のプライベート露天風呂で相互愛撫して、湯船の縁や和室で様々な体位で合体！"\
      "感じ過ぎて何度もイク！食事したら浴衣に着替え寝床へ。"\
      "両手を帯紐で拘束されながら玩具責めにヨガル！"\
      "美味しそうに肉棒をしゃぶったら、横になった男に跨り腰を上下して快楽を貪る！"
    )
    details[:sample_images].must_equal([
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_0_aby-003.jpg",
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_1_aby-003.jpg",
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_2_aby-003.jpg",
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_3_aby-003.jpg",
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_4_aby-003.jpg",
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_5_aby-003.jpg",
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_6_aby-003.jpg",
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_7_aby-003.jpg",
      "http://image.prestige-av.com/images/prestige/aby/003/cap_e_8_aby-003.jpg"
    ])
    details[:review].must_equal        ""
end
end