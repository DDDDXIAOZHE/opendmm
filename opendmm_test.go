package opendmm

import (
	"sync"
	"testing"
)

func TestOpendmmSearch(t *testing.T) {
	queries := []string{
		"SDDE-201",
		"200GANA-894",
		"3DSVR-106",
	}
	wg := new(sync.WaitGroup)
	for _, query := range queries {
		wg.Add(1)
		go func(query string) {
			defer wg.Done()
			for attempt, maxAttempt := 1, 5; ; attempt++ {
				metach := Search(query)
				meta, ok := <-metach
				if ok {
					t.Logf("%s -> %+v", query, meta)
					break
				}
				if attempt < maxAttempt {
					t.Logf("Attempt #%d failed for %s", attempt, query)
				} else {
					t.Fatalf("All %d attempts failed for %s", maxAttempt, query)
				}
			}
		}(query)
	}
	wg.Wait()
}

func TestOpendmmGuess(t *testing.T) {
	queries := []string{
		"SDDE-201",
	}
	for _, query := range queries {
		if !Guess(query + "_suffix").Contains(query) {
			t.Fatalf("Guessed wrong code for %s with suffix", query)
		}
		if !Guess("prefix_" + query).Contains(query) {
			t.Fatalf("Guessed wrong code for %s with prefix", query)
		}
	}
}
