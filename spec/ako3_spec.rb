require "minitest/autorun"
require "opendmm"

describe OpenDMM::Ako3 do
  it "supports AKO series" do
    details = OpenDMM::Ako3.search("AKO-011")
    details[:title].must_equal         "MARI 18歳"
    details[:cover_image].must_equal   "http://www.ako-3.com/img/jacket/AKO011.jpg"
    details[:actresses].must_equal({
      "MARI［まり］" => {
        face_image: "http://www.ako-3.com/img/jacket_s/AKO011.jpg",
        age:        "18歳",
        height:     "160cm",
        size:       "B80（B-65）/W58/H83"
      }
    })
    details[:maker].must_equal         "A子さん"
    details[:product_id].must_equal    "AKO011"
    details[:release_date].must_equal  "2011年11月12日"
    details[:information].must_equal(
      "コスプレしてみたりソフトSMをしてみたいというMARIちゃんは、"\
      "爽やかイケメンがタイプで男に関しては色々うるさそう。"\
      "そんな彼女のお餅みたく白くて柔らかい上物パイオツをぺろぺろナメナメしたり、"\
      "アソコをぐっちょぐっちょ掻き回すと、カワイイ声で喘ぐスケベちゃんに豹変。"\
      "で、ズッポリ挿入、フィニッシュは舌上、で、ごっくんしてくれたよ。"\
      "で、おまけに、セックス後のシャワー室に侵入し、俺の乳首をイジらせ、"\
      "フェラに持ち込み「ぐえっ」っと咽る彼女を尻目に精子を舐めさせちゃったぜ！"
    )
    details[:sample_images].must_equal([
      "http://www.ako-3.com/SampleImg_b/AKO011_01.jpg",
      "http://www.ako-3.com/SampleImg_b/AKO011_02.jpg",
      "http://www.ako-3.com/SampleImg_b/AKO011_03.jpg",
      "http://www.ako-3.com/SampleImg_b/AKO011_04.jpg",
      "http://www.ako-3.com/SampleImg_b/AKO011_05.jpg",
    ])
  end
end