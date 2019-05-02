package opendmm

import (
	"fmt"
	"net/http"
	"net/url"
	"regexp"
	"strings"
	"sync"

	"github.com/PuerkitoBio/goquery"
	"github.com/junzh0u/httpx"
)

func dmmEngine(keyword string, wg *sync.WaitGroup, metach chan MovieMeta) {
	urlstr := fmt.Sprintf(
		"http://www.dmm.co.jp/search/=/searchstr=%s",
		url.QueryEscape(
			regexp.MustCompile("(?i)[a-z].*").FindString(keyword),
		),
	)
	doc, err := newDocument(urlstr, httpx.ReadBodyInUTF8(http.Get))
	if err != nil {
		return
	}

	doc.Find("#list > li > div > p.tmb > a").Each(
		func(i int, a *goquery.Selection) {
			href, ok := a.Attr("href")
			if ok {
				wg.Add(1)
				go func() {
					defer wg.Done()
					dmmParse(href, keyword, metach)
				}()
			}
		})
}

func dmmParse(urlstr string, keyword string, metach chan MovieMeta) {
	doc, err := newDocument(urlstr, httpx.ReadBodyInUTF8(http.Get))
	if err != nil {
		return
	}

	var meta MovieMeta
	var ok bool
	meta.Page = urlstr
	meta.Title = doc.Find(".area-headline h1").Text()
	meta.ThumbnailImage, _ = doc.Find("#sample-video img").Attr("src")
	meta.CoverImage, ok = doc.Find("#sample-video a").Attr("href")
	if !ok || strings.HasPrefix(meta.CoverImage, "javascript") {
		meta.CoverImage = meta.ThumbnailImage
	}
	doc.Find("div.page-detail > table > tbody > tr > td > table > tbody > tr").Each(
		func(i int, tr *goquery.Selection) {
			td := tr.Find("td").First()
			k := td.Text()
			v := td.Next()
			if strings.Contains(k, "開始日") || strings.Contains(k, "発売日") {
				date := strings.TrimSpace(v.Text())
				matched, _ := regexp.MatchString("^-+$", date)
				if !matched {
					meta.ReleaseDate = date
				}
			} else if strings.Contains(k, "収録時間") {
				meta.MovieLength = v.Text()
			} else if strings.Contains(k, "出演者") {
				meta.Actresses = v.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			} else if strings.Contains(k, "監督") {
				meta.Directors = v.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			} else if strings.Contains(k, "シリーズ") {
				meta.Series = v.Text()
			} else if strings.Contains(k, "メーカー") {
				meta.Maker = v.Text()
			} else if strings.Contains(k, "レーベル") {
				meta.Label = v.Text()
			} else if strings.Contains(k, "ジャンル") {
				meta.Genres = v.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			} else if strings.Contains(k, "品番") {
				meta.Code = normalizeCode(v.Text())
			}
		})

	if codeEquals(keyword, meta.Code) {
		metach <- meta
	}
}
