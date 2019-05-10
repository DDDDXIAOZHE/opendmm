package opendmm

import (
	"fmt"
	"net/http"
	"net/url"
	"regexp"
	"strings"
	"sync"

	"github.com/PuerkitoBio/goquery"
)

func deepsGet(url string) (*http.Response, error) {
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Add("Referer", "http://deeps.net/")
	return http.DefaultClient.Do(req)
}

func deepsEngine(keyword string, wg *sync.WaitGroup, metach chan MovieMeta) {
	urlstr := fmt.Sprintf(
		"http://deeps.net/item/all.html?q=%s",
		url.QueryEscape(keyword),
	)
	doc, err := newDocument(urlstr, deepsGet)
	if err != nil {
		return
	}

	doc.Find("#rightColumn > section > ul > li > dl > dd.image > a").Each(
		func(i int, a *goquery.Selection) {
			href, ok := a.Attr("href")
			if ok {
				href, err := joinURLs("http://deeps.net/", href)
				if err != nil {
					return
				}
				wg.Add(1)
				go func() {
					defer wg.Done()
					deepsParse(href, keyword, metach)
				}()
			}
		})
}

func deepsParse(urlstr string, keyword string, metach chan MovieMeta) {
	doc, err := newDocument(urlstr, deepsGet)
	if err != nil {
		return
	}

	var meta MovieMeta
	meta.Maker = "ディープス"
	meta.Page = urlstr
	meta.Title = doc.Find("span.itemTitle").Text()
	meta.CoverImage, _ = doc.Find("div.itemJk img").Attr("src")
	meta.CoverImage, _ = joinURLs("http://deeps.net/", meta.CoverImage)
	meta.Description = doc.Find("span.itemText").Text()
	doc.Find("div.itemInfo > dl").Each(
		func(i int, dl *goquery.Selection) {
			dt := dl.Find("dt").Text()
			dd := dl.Find("dd")
			if strings.Contains(dt, "発売日") {
				meta.ReleaseDate = strings.TrimSpace(dd.Text())
			} else if strings.Contains(dt, "収録時間") {
				meta.MovieLength = dd.Text()
			} else if strings.Contains(dt, "出演") {
				meta.Actresses = regexp.MustCompile("\\s+").Split(dd.Text(), -1)
			} else if strings.Contains(dt, "監督") {
				meta.Directors = dd.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			} else if strings.Contains(dt, "シリーズ") {
				meta.Series = dd.Text()
			} else if strings.Contains(dt, "品番") {
				meta.Code = normalizeCode(dd.Text())
			}
		})

	if codeEquals(keyword, meta.Code) {
		metach <- meta
	}
}
