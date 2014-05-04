require_relative "../helpers/fixture_test_helper"

class AKOTest < Minitest::Test
  include FixtureTest

  def setup
    @fixtures = {
      "AKO-011" => {
        page:         "http://www.ako-3.com/work/item.php?itemcode=AKO011",
        product_id:   "AKO011",
        title:        "MARI 18歳",
        maker:        "A子さん",
        release_date: "2011年11月12日",
        actresses: {
          "MARI［まり］" => {
            face:   "http://www.ako-3.com/img/jacket_s/AKO011.jpg",
            age:    "18歳",
            height: "160cm",
            size:   "B80（B-65）/W58/H83",
          },
        },
        images: {
          cover:   "http://www.ako-3.com/img/jacket/AKO011.jpg",
          samples: [
            "http://www.ako-3.com/SampleImg_b/AKO011_01.jpg",
            "http://www.ako-3.com/SampleImg_b/AKO011_02.jpg",
            "http://www.ako-3.com/SampleImg_b/AKO011_03.jpg",
            "http://www.ako-3.com/SampleImg_b/AKO011_04.jpg",
            "http://www.ako-3.com/SampleImg_b/AKO011_05.jpg",
          ],
        },
        descriptions: [
          "コスプレしてみたりソフトSMをしてみたいというMARIちゃんは、"\
          "爽やかイケメンがタイプで男に関しては色々うるさそう。"\
          "そんな彼女のお餅みたく白くて柔らかい上物パイオツをぺろぺろナメナメしたり、"\
          "アソコをぐっちょぐっちょ掻き回すと、カワイイ声で喘ぐスケベちゃんに豹変。"\
          "で、ズッポリ挿入、フィニッシュは舌上、で、ごっくんしてくれたよ。"\
          "で、おまけに、セックス後のシャワー室に侵入し、俺の乳首をイジらせ、"\
          "フェラに持ち込み「ぐえっ」っと咽る彼女を尻目に精子を舐めさせちゃったぜ！",
        ],
      }
    }
  end
end
