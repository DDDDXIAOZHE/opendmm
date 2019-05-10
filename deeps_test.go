package opendmm

import (
	"testing"
)

func TestDeeps(t *testing.T) {
	assertSearchable(
		t,
		[]string{
			"DVDMS-392",
		},
		deepsEngine,
	)
}
