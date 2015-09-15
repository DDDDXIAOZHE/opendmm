[![Build Status](https://travis-ci.org/opendmm/opendmm.svg)](https://travis-ci.org/opendmm/opendmm)

# What?

In short, given an AV's ID, OpenDMM fetch the detailed information for you.

It's a ruby gem so you can use it anywhere in you code:

    irb(main):001:0> require 'opendmm'
    => true
    irb(main):002:0> OpenDMM.search 'ABP-123'
    => {:actresses=>["酒井 ももか"], :code=>"ABP-123", :cover_image=>"http://www.prestige-av.com/images/corner/goods/prestige/abp/123/pb_e_abp-123.jpg", :description=>"通販限定商品！未公開映像収録DVDの特典付き商品です。本数限定となりますのでお早めにお求め下さい！！プレステージ専属女優 『酒井 ももか』 が新人泡姫に！可愛い顔で落ち着いた空間を演出して、ゆっくりとした時間の流れを作ってお客様に満足頂けるサービスをご提供！感じる個所を的確に責めて気持ち良くフィニッシュに導くシーンは見逃せません！硬くなったチ○コと交わり、夢心地で快感を堪能 してイク・・・。", :genres=>["玩具責め", "女優", "アナル舐め", "通販限定"], :label=>"ABSOLUTELY PERFECT", :maker=>"プレステージ", :movie_length=>8400, :page=>"http://www.prestige-av.com/goods/goods_detail.php?sku=ABP-123", :release_date=>#<Date: 2014-04-01 ((2456749j,0s,0n),+0s,2299161j)>, :sample_images=>["http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_0_abp-123.jpg", "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_1_abp-123.jpg", "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_2_abp-123.jpg", "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_3_abp-123.jpg", "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_4_abp-123.jpg", "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_5_abp-123.jpg", "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_6_abp-123.jpg", "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_7_abp-123.jpg"], :series=>"満足度満点ソープ", :thumbnail_image=>"http://www.prestige-av.com/images/corner/goods/prestige/abp/123/pf_p_abp-123.jpg", :title=>"酒井ももか 満足度満点新人ソープDX＋未公開映像DVD付き"}

A command line tool is also provided:

    $ opendmm 'ABP-123'
    {
      "actresses": [
        "酒井 ももか"
      ],
      "code": "ABP-123",
      "cover_image": "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/pb_e_abp-123.jpg",
      "description": "通販限定商品！未公開映像収録DVDの特典付き商品です。本数限定となりますのでお早めにお求め下さい！！プレステージ専属女優 『酒井 ももか』 が新人泡姫に！可愛い顔で落ち着いた空間を演出して、ゆっくりとした時間の流れを作ってお客様に満足頂けるサービスをご提供！感じる個所を的確に責めて気持ち良くフィニッシュに導くシーンは見逃せません！硬くなったチ○コと交わり、夢心地で快感を堪能してイク・・・。",
      "genres": [
        "玩具責め",
        "女優",
        "アナル舐め",
        "通販限定"
      ],
      "label": "ABSOLUTELY PERFECT",
      "maker": "プレステージ",
      "movie_length": 8400,
      "page": "http://www.prestige-av.com/goods/goods_detail.php?sku=ABP-123",
      "release_date": "2014-04-01",
      "sample_images": [
        "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_0_abp-123.jpg",
        "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_1_abp-123.jpg",
        "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_2_abp-123.jpg",
        "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_3_abp-123.jpg",
        "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_4_abp-123.jpg",
        "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_5_abp-123.jpg",
        "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_6_abp-123.jpg",
        "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/cap_e_7_abp-123.jpg"
      ],
      "series": "満足度満点ソープ",
      "thumbnail_image": "http://www.prestige-av.com/images/corner/goods/prestige/abp/123/pf_p_abp-123.jpg",
      "title": "酒井ももか 満足度満点新人ソープDX＋未公開映像DVD付き"
    }

# Why?

[DMM](http://www.dmm.co.jp) is the obvious choice when this kind of use cases come to your mind, which do have an [API](https://affiliate.dmm.com/api/reference/r18/all/) available.

Although it's widely used by many AV sites, it's not that easy to use when it comes to personal usage. Because in order to use it you have to register your site and get approval.

So I build this tool, to provide an easy-to-use alternative. It also provides more accurate result, which you can see from the "How?" section.

## Where it excels?

Give these a try:

    $ opendmm "S-Cute 352_kokona_02"
    $ opendmm SIRO-1088
    $ opendmm "Carib 021511-620"

Then try search them on DMM, or use DMM API if you have an app key.

It also provides you more detailed information than DMM if you noticed. For example, did you see the `sample_images` part in the example json above?

# How?

## How to use?

    gem install opendmm

## How does it work?

1. It will try fetch information from official maker site first, which should have the most accurate and comprehensive information, for example sample images. Currently only a few makers' sites are supported, but more and more is coming.
2. As backup, if step 1 fails. It will try several existing search engines. For now we have:
    * [JavLibrary](http://www.javlibrary.com)
    * [DMM](http://www.dmm.co.jp)
    * [MGStage](http://www.mgstage.com)
    * [AvEntertainments](http://www.aventertainments.com)

# You can help

Feel free to report errors or request support for maker's site. Just [file a Issue](https://github.com/opendmm/opendmm/issues).

You can see current developing plan including makers planed to support on [Trello](https://trello.com/b/Q3P91c7N/opendmm).

# License

OpenDMM is released under [MIT License](http://opensource.org/licenses/MIT).
