package opendmm

import (
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"sync"

	"github.com/junzh0u/httpx"

	"github.com/PuerkitoBio/goquery"
)

func aveEngine(keyword string, wg *sync.WaitGroup, metach chan MovieMeta) {
	urlstr := fmt.Sprintf(
		"http://www.aventertainments.com/search_Products.aspx?keyword=%s",
		url.QueryEscape(keyword),
	)
	doc, err := newDocument(urlstr, httpx.ReadBodyInUTF8(http.Get))
	if err != nil {
		return
	}

	doc.Find("div.main-unit2 > table a").Each(
		func(i int, a *goquery.Selection) {
			href, ok := a.Attr("href")
			if ok {
				wg.Add(1)
				go func() {
					defer wg.Done()
					aveParse(href, keyword, metach)
				}()
			}
		})
}

func aveParse(urlstr string, keyword string, metach chan MovieMeta) {
	doc, err := newDocument(urlstr, httpx.ReadBodyInUTF8(http.Get))
	if err != nil {
		return
	}

	var meta MovieMeta
	var ok bool
	meta.Page = urlstr
	meta.Title = doc.Find("#mini-tabet > h2").Text()
	meta.CoverImage, ok = doc.Find("#titlebox > div.list-cover > img").Attr("src")
	if ok {
		meta.CoverImage = strings.Replace(meta.CoverImage, "jacket_images", "bigcover", -1)
	}
	meta.Code = strings.TrimSpace(strings.Replace(doc.Find("#mini-tabet > div").Text(), "商品番号:", "", -1))
	doc.Find("#titlebox > ul > li").Each(
		func(i int, li *goquery.Selection) {
			k := li.Find("span").Text()
			if strings.Contains(k, "主演女優") {
				meta.Actresses = li.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			} else if strings.Contains(k, "スタジオ") {
				meta.Maker = li.Find("a").Text()
			} else if strings.Contains(k, "シリーズ") {
				meta.Series = li.Find("a").Text()
			} else if strings.Contains(k, "発売日") {
				meta.ReleaseDate = li.Text()
			} else if strings.Contains(k, "収録時間") {
				meta.MovieLength = li.Text()
			}
		})

	if codeEquals(keyword, meta.Code) {
		metach <- meta
	}
}
