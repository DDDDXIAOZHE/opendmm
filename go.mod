module github.com/libredmm/opendmm

require (
	github.com/PuerkitoBio/goquery v1.5.0
	github.com/andybalholm/cascadia v1.0.0
	github.com/benbjohnson/phantomjs v0.0.0-20181211182228-6499a20f5cd6
	github.com/deckarep/golang-set v1.7.1
	github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b
	github.com/golang/protobuf v1.3.1 // indirect
	github.com/golang/snappy v0.0.1
	github.com/heroku/x v0.0.0-20181102215100-85e5aa5e6aa1
	github.com/junzh0u/httpx v0.0.0-20190502193134-341a0460d6dd
	github.com/junzh0u/ioutilx v0.0.0-20180827205417-117bc779d863
	github.com/onsi/ginkgo v1.8.0 // indirect
	github.com/onsi/gomega v1.5.0 // indirect
	github.com/stretchr/objx v0.2.0 // indirect
	github.com/stretchr/testify v1.3.0
	github.com/syndtr/goleveldb v1.0.0
	golang.org/x/net v0.0.0-20190502183928-7f726cade0ab
	golang.org/x/text v0.3.2
	gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127 // indirect
	gopkg.in/yaml.v2 v2.2.2 // indirect
)

// +heroku goVersion go1.11
// +heroku install ./cmd/...
