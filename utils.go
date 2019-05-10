package opendmm

import (
	"net/http"
	"net/url"
	"path"
	"strings"

	"github.com/PuerkitoBio/goquery"
	"github.com/junzh0u/httpx"
)

type getfunc func(string) (*http.Response, error)

func newDocument(url string, get getfunc) (*goquery.Document, error) {
	content, err := httpx.ReadBodyX(get(url))
	if err != nil {
		return nil, err
	}
	return goquery.NewDocumentFromReader(strings.NewReader(content))
}

func joinURLs(base string, relative string) (string, error) {
	baseURL, err := url.Parse(base)
	if err != nil {
		return "", err
	}
	baseURL.Path = path.Join(baseURL.Path, relative)
	return baseURL.String(), nil
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
