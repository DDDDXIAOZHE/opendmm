package opendmm

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

type code struct {
	series string
	prefix string
	number int
}

func (c code) toString() string {
	if c.prefix == "" {
		return fmt.Sprintf("%s-%03d", c.series, c.number)
	}
	return fmt.Sprintf("%s-%s%02d", c.series, c.prefix, c.number)
}

func (c code) variations() map[string]bool {
	if c.prefix == "" {
		return map[string]bool{
			fmt.Sprintf("%s-%02d", c.series, c.number): true,
			fmt.Sprintf("%s-%03d", c.series, c.number): true,
			fmt.Sprintf("%s-%04d", c.series, c.number): true,
			fmt.Sprintf("%s-%05d", c.series, c.number): true,
		}
	}
	return map[string]bool{
		fmt.Sprintf("%s-%s%02d", c.series, c.prefix, c.number): true,
	}
}

func guessCodes(query string) map[code]bool {
	re := regexp.MustCompile(
		"(?i)(\\d{3})?((?:3d|2d|s2|[a-z]){1,7})[-_]?([sm]?)(0*(\\d{2,5}))",
	)
	matches := re.FindAllStringSubmatch(query, -1)
	codes := make(map[code]bool)
	for _, match := range matches {
		n, err := strconv.Atoi(match[4])
		if err == nil {
			codes[code{
				series: strings.ToUpper(match[2]),
				prefix: strings.ToUpper(match[3]),
				number: n,
			}] = true
			codes[code{
				series: strings.ToUpper(match[1] + match[2]),
				prefix: strings.ToUpper(match[3]),
				number: n,
			}] = true
		}
	}
	return codes
}

func normalizeCode(txt string) string {
	for code := range guessCodes(txt) {
		return code.toString()
	}
	return txt
}

func codeEquals(lcode, rcode string) bool {
	lvars := guessCodes(lcode)
	rvars := guessCodes(rcode)
	for lvar := range lvars {
		if rvars[lvar] {
			return true
		}
	}
	return false
}
