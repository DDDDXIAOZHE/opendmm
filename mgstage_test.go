package opendmm

import (
	"testing"
)

func TestMgstage(t *testing.T) {
	assertSearchable(
		t,
		[]string{
			"SIRO-1715",
			"200GANA-894",
			"259LUXU-011",
			"3DSVR-200",
		},
		mgsEngine,
	)
}
