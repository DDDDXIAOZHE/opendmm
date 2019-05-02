package opendmm

import (
	"net/url"
	"strings"

	"github.com/PuerkitoBio/goquery"
	"github.com/junzh0u/httpx"
)

func newDocument(url string, readbody httpx.ReadBodyFunc) (*goquery.Document, error) {
	content, err := readbody(url)
	if err != nil {
		return nil, err
	}
	return goquery.NewDocumentFromReader(strings.NewReader(content))
}

func normalizeURL(in string) string {
	if in == "" {
		return ""
	}
	u, _ := url.Parse(in)
	if u.Scheme == "" {
		u.Scheme = "http"
	}
	return u.String()
}

func normalizeURLs(in []string) []string {
	var out []string
	for _, s := range in {
		out = append(out, normalizeURL(s))
	}
	return out
}
