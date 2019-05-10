package opendmm

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestCodeToString(t *testing.T) {
	assert := assert.New(t)
	assert.Equal(code{series: "DUMMY", number: 10}.toString(), "DUMMY-010")
	assert.Equal(code{series: "DUMMY", number: 100}.toString(), "DUMMY-100")
	assert.Equal(code{series: "DUMMY", number: 1000}.toString(), "DUMMY-1000")
	assert.Equal(code{series: "DUMMY", prefix: "S", number: 1}.toString(), "DUMMY-S01")
	assert.Equal(code{series: "DUMMY", prefix: "S", number: 10}.toString(), "DUMMY-S10")
	assert.Equal(code{series: "DUMMY", prefix: "S", number: 100}.toString(), "DUMMY-S100")
}

func TestCodeVariations(t *testing.T) {
	assert := assert.New(t)
	assert.Equal(
		map[string]bool{
			"MIDE-29":    true,
			"MIDE-029":   true,
			"MIDE-0029":  true,
			"MIDE-00029": true,
		},
		code{series: "MIDE", number: 29}.variations(),
	)
	assert.Equal(
		map[string]bool{
			"3DSVR-106":   true,
			"3DSVR-0106":  true,
			"3DSVR-00106": true,
		},
		code{series: "3DSVR", number: 106}.variations(),
	)
	assert.Equal(
		map[string]bool{
			"XV-1001":  true,
			"XV-01001": true,
		},
		code{series: "XV", number: 1001}.variations(),
	)
	assert.Equal(
		map[string]bool{
			"MKBD-S96": true,
		},
		code{series: "MKBD", prefix: "S", number: 96}.variations(),
	)
	assert.Equal(
		map[string]bool{
			"MKBD-S100": true,
		},
		code{series: "MKBD", prefix: "S", number: 100}.variations(),
	)
}

func TestGuessCodes(t *testing.T) {
	assert := assert.New(t)
	assert.Equal(
		map[code]bool{
			code{
				series: "MIDE",
				number: 29,
			}: true,
		},
		guessCodes("MIDE-029"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "XV",
				number: 1001,
			}: true,
		},
		guessCodes("XV-1001"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "IPZ",
				number: 687,
			}: true,
		},
		guessCodes("IPZ687"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "MMGH",
				number: 10,
			}: true,
		},
		guessCodes("MMGH00010"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "C",
				number: 2202,
			}: true,
			code{
				series: "140C",
				number: 2202,
			}: true,
		},
		guessCodes("140c02202"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "3DSVR",
				number: 100,
			}: true,
		},
		guessCodes("3DSVR-100"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "GANA",
				number: 894,
			}: true,
			code{
				series: "200GANA",
				number: 894,
			}: true,
		},
		guessCodes("200GANA-894"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "CW3D2DBD",
				number: 30,
			}: true,
		},
		guessCodes("CW3D2DBD-30"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "MKBD",
				prefix: "S",
				number: 97,
			}: true,
		},
		guessCodes("MKBD-S97"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "CWPBD",
				number: 77,
			}: true,
		},
		guessCodes("CWPBD_77"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "C",
				number: 2202,
			}: true,
			code{
				series: "140C",
				number: 2202,
			}: true,
			code{
				series: "3DSVR",
				number: 100,
			}: true,
		},
		guessCodes("140c02202 3DSVR-100"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "DVDMS",
				number: 393,
			}: true,
		},
		guessCodes("DVDMS00393"),
	)
	assert.Equal(
		map[code]bool{
			code{
				series: "T",
				number: 28,
			}: true,
			code{
				series: "T28",
				number: 558,
			}: true,
		},
		guessCodes("T28-558"),
	)
}
