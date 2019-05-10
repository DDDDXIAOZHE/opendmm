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

func kvEngine(
	keyword string,
	wg *sync.WaitGroup,
	metach chan MovieMeta) {
	urlstrs := []string{
		fmt.Sprintf(
			"https://www.knights-visual.com/works/%s/",
			url.QueryEscape(keyword),
		),
	}
	for _, urlstr := range urlstrs {
		wg.Add(1)
		go func(urlstr string) {
			defer wg.Done()
			kvParseProductPage(keyword, urlstr, wg, metach)
		}(urlstr)
	}
}

func kvParseProductPage(
	keyword string,
	urlstr string,
	wg *sync.WaitGroup,
	metach chan MovieMeta) {
	doc, err := newDocument(urlstr, http.Get)
	if err != nil {
		return
	}

	var meta MovieMeta
	meta.Page = urlstr
	meta.Title = doc.Find("h1.entry-title").Text()
	meta.CoverImage, _ = doc.Find(
		"div.entry-content > p:nth-child(1) > a").Attr("href")
	meta.ThumbnailImage, _ = doc.Find(
		"div.entry-content > p:nth-child(1) > a > img").Attr("src")
	dateRe := regexp.MustCompile("\\d+/\\d+/\\d+")
	meta.ReleaseDate = dateRe.FindString(doc.Find("div.info").Text())

	doc.Find("div.kvp_goods_info_table table tbody tr").Each(
		func(i int, tr *goquery.Selection) {
			label := tr.Find("td.label").First().Text()
			data := tr.Find("td.data").First()
			if strings.Contains(label, "商品番号") {
				meta.Code = normalizeCode(data.Text())
			} else if strings.Contains(label, "シリーズ") {
				meta.Series = data.Text()
			} else if strings.Contains(label, "出演者") {
				meta.Actresses = strings.Split(data.Text(), " ")
			} else if strings.Contains(label, "作者	") {
				meta.Directors = strings.Split(data.Text(), " ")
			} else if strings.Contains(label, "収録時間") {
				meta.MovieLength = data.Text()
			}
		})

	if codeEquals(keyword, meta.Code) {
		metach <- meta
	}
}
