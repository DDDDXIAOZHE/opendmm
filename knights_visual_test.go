package opendmm

import (
	"testing"
)

func TestKnightsVisual(t *testing.T) {
	assertSearchable(
		t,
		[]string{
			"KV-151",
		},
		kvEngine,
	)
}
