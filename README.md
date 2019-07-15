# OpenDMM

[![Build Status](https://travis-ci.org/libredmm/opendmm.svg?branch=master)](https://travis-ci.org/libredmm/opendmm)
[![codecov](https://codecov.io/gh/libredmm/opendmm/branch/master/graph/badge.svg)](https://codecov.io/gh/libredmm/opendmm)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/libredmm/opendmm/blob/master/LICENSE)
[![Godoc Reference](https://github.com/golang/gddo/blob/master/gddo-server/assets/status.svg)](https://godoc.org/github.com/libredmm/opendmm)

This Go Librady/CLI fetches AV metadata given a code (番号).

## Installation & Usage

    $ go install github.com/libredmm/opendmm/cmd/opendmm
    $ opendmm "SDDE-222"
    {
      "Actresses": [
        "橘美穂",
        "広瀬奏",
        "なのかひより",
        "直嶋あい",
        "羽月希"
      ],
      "ActressTypes": null,
      "Categories": null,
      "Code": "SDDE-222",
      "CoverImage": "https://pics.dmm.co.jp/digital/video/1sdde00222/1sdde00222pl.jpg",
      "Description": "",
      "Directors": [
        "雄次郎"
      ],
      "Genres": [
        "企画",
        "看護婦・ナース",
        "手コキ"
      ],
      "Label": "SODクリエイト",
      "Maker": "SODクリエイト",
      "MovieLength": "117分",
      "Page": "http://www.dmm.co.jp/digital/videoa/-/detail/=/cid=1sdde00222/?i3_ref=search\u0026i3_ord=5",
      "ReleaseDate": "2010/07/08",
      "SampleImages": null,
      "Series": "（裏）手コキクリニック",
      "Tags": null,
      "ThumbnailImage": "https://pics.dmm.co.jp/digital/video/1sdde00222/1sdde00222ps.jpg",
      "Title": "（裏）手コキクリニック ～完全版～ 性交クリニック6"
    }

It's also available as a library. See [the CLI code](https://github.com/libredmm/opendmm/blob/master/cmd/opendmm/opendmm.go) for example usage.
