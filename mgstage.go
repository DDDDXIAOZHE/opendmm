package opendmm

import (
	"fmt"
	"net/http"
	"net/url"
	"regexp"
	"strings"
	"sync"
	"time"

	"github.com/PuerkitoBio/goquery"
	"github.com/junzh0u/httpx"
)

var mgsCookies = []*http.Cookie{&http.Cookie{
	Name:     "adc",
	Value:    "1",
	Domain:   ".mgstage.com",
	Path:     "/",
	HttpOnly: false,
	Secure:   false,
	Expires:  time.Now().Add(1000 * time.Hour),
}}

func mgsEngine(
	keyword string,
	wg *sync.WaitGroup,
	metach chan MovieMeta) {
	urlstrs := []string{
		fmt.Sprintf(
			"https://www.mgstage.com/search/search.php?search_word=%s&search_shop_id=shiroutotv",
			url.QueryEscape(keyword),
		),
		fmt.Sprintf(
			"https://www.mgstage.com/search/search.php?search_word=%s&search_shop_id=nanpatv",
			url.QueryEscape(keyword),
		),
		fmt.Sprintf(
			"https://www.mgstage.com/search/search.php?search_word=%s",
			url.QueryEscape(keyword),
		),
	}
	for _, urlstr := range urlstrs {
		wg.Add(1)
		go func(urlstr string) {
			defer wg.Done()
			mgsParseSearchPage(keyword, urlstr, wg, metach)
		}(urlstr)
	}
}

func mgsParseSearchPage(
	keyword string,
	urlstr string,
	wg *sync.WaitGroup,
	metach chan MovieMeta) {
	doc, err := newDocument(
		urlstr,
		httpx.ReadBodyInUTF8(httpx.GetWithCookies(mgsCookies)),
	)
	if err != nil {
		return
	}

	urlbase, err := url.Parse(urlstr)
	doc.Find("#center_column > div.all_search_list > ul > li > a, #center_column > div.search_list > div > ul > li > a").Each(
		func(i int, a *goquery.Selection) {
			wg.Add(1)
			go func(a *goquery.Selection) {
				defer wg.Done()
				href, ok := a.Attr("href")
				if !ok {
					return
				}
				urlhref, err := urlbase.Parse(href)
				if err != nil {
					return
				}
				wg.Add(1)
				go func() {
					defer wg.Done()
					mgsParseProductPage(urlhref.String(), keyword, metach)
				}()
			}(a)
		})
}

func mgsParseProductPage(urlstr string, keyword string, metach chan MovieMeta) {
	doc, err := newDocument(
		urlstr,
		httpx.ReadBodyInUTF8(httpx.GetWithCookies(mgsCookies)))
	if err != nil {
		return
	}

	var meta MovieMeta
	meta.Page = urlstr
	meta.Title = doc.Find("#center_column h1.tag").Text()
	meta.CoverImage, _ = doc.Find("#center_column a#EnlargeImage").Attr("href")

	dateRe := regexp.MustCompile("\\d+/\\d+/\\d+")
	meta.ReleaseDate = dateRe.FindString(doc.Find("span.date").Text())

	doc.Find("ul.detail_txt > li").Each(
		func(i int, li *goquery.Selection) {
			text := li.Text()
			if strings.Contains(text, "シリーズ") {
				meta.Series = li.Find("a").Text()
			} else if strings.Contains(text, "出演者") {
				meta.Actresses = li.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			} else if strings.Contains(text, "ジャンル") {
				meta.Genres = li.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			} else {
				re := regexp.MustCompile("・([^・]*)：([^・]*)")
				matches := re.FindAllStringSubmatch(text, -1)
				for _, match := range matches {
					key := strings.TrimSpace(match[1])
					value := strings.TrimSpace(match[2])
					switch key {
					case "収録時間":
						meta.MovieLength = value
					case "品番":
						meta.Code = value
					}
				}
			}
		})

	doc.Find("div.detail_data > table > tbody > tr").Each(
		func(i int, tr *goquery.Selection) {
			th := tr.Find("th").First()
			k := strings.TrimSpace(th.Text())
			td := tr.Find("td").First()
			if strings.Contains(k, "出演") {
				meta.Actresses = td.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			} else if strings.Contains(k, "メーカー") {
				meta.Maker = td.Text()
			} else if strings.Contains(k, "収録時間") {
				meta.MovieLength = td.Text()
			} else if strings.Contains(k, "品番") {
				meta.Code = td.Text()
			} else if strings.Contains(k, "配信開始日") {
				meta.ReleaseDate = td.Text()
			} else if strings.Contains(k, "シリーズ") {
				meta.Series = td.Text()
			} else if strings.Contains(k, "レーベル") {
				meta.Label = td.Text()
			} else if strings.Contains(k, "ジャンル") {
				meta.Genres = td.Find("a").Map(
					func(i int, a *goquery.Selection) string {
						return a.Text()
					})
			}
		})

	if codeEquals(keyword, meta.Code) {
		metach <- meta
	}
}
