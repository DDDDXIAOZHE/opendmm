package opendmm

import (
	"reflect"
	"regexp"
	"strings"
)

func deduplicate(in chan MovieMeta) chan MovieMeta {
	out := make(chan MovieMeta)
	go func(out chan MovieMeta) {
		defer close(out)
		for meta := range in {
			segments := regexp.MustCompile("\\s").Split(meta.Title, -1)
			for i, segment := range segments {
				if segment == meta.Code {
					segments[i] = ""
				} else {
					for _, actress := range meta.Actresses {
						if segment == actress {
							segments[i] = ""
							break
						}
					}
				}
			}
			meta.Title = strings.Join(segments, " ")
			out <- meta
		}
	}(out)
	return out
}

func trimSpaces(in chan MovieMeta) chan MovieMeta {
	out := make(chan MovieMeta)
	go func(out chan MovieMeta) {
		defer close(out)
		for meta := range in {
			value := reflect.ValueOf(&meta).Elem()
			for fi := 0; fi < value.NumField(); fi++ {
				field := value.Field(fi)
				switch field.Interface().(type) {
				case string:
					str := field.String()
					str = strings.TrimSpace(str)
					str = regexp.MustCompile("\\s+").ReplaceAllString(str, " ")
					field.SetString(str)
				case []string:
					for ei := 0; ei < field.Len(); ei++ {
						elem := field.Index(ei)
						str := elem.String()
						str = strings.TrimSpace(str)
						str = regexp.MustCompile("\\s+").ReplaceAllString(str, " ")
						elem.SetString(str)
					}
				}
			}
			out <- meta
		}
	}(out)
	return out
}

func validateFields(in chan MovieMeta) chan MovieMeta {
	out := make(chan MovieMeta)
	go func(out chan MovieMeta) {
		defer close(out)
		for meta := range in {
			if meta.Code == "" ||
				meta.Title == "" ||
				meta.CoverImage == "" ||
				strings.HasPrefix(meta.CoverImage, "javascript") {
			} else {
				out <- meta
			}
		}
	}(out)
	return out
}

func normalizeCodeField(in chan MovieMeta) chan MovieMeta {
	out := make(chan MovieMeta)
	re := regexp.MustCompile("^(\\w+-)0+(\\d{3,})$")
	go func(out chan MovieMeta) {
		defer close(out)
		for meta := range in {
			meta.Code = re.ReplaceAllString(meta.Code, "$1$2")
			out <- meta
		}
	}(out)
	return out
}

func normalizeURLFields(in chan MovieMeta) chan MovieMeta {
	out := make(chan MovieMeta)
	go func(out chan MovieMeta) {
		defer close(out)
		for meta := range in {
			meta.CoverImage = normalizeURL(meta.CoverImage)
			meta.Page = normalizeURL(meta.Page)
			meta.SampleImages = normalizeURLs(meta.SampleImages)
			meta.ThumbnailImage = normalizeURL(meta.ThumbnailImage)
			out <- meta
		}
	}(out)
	return out
}

func postProcess(in chan MovieMeta) chan MovieMeta {
	return normalizeURLFields(normalizeCodeField(validateFields(trimSpaces(deduplicate(in)))))
}
