package opendmm

import (
	"sync"
	"testing"
)

func assertSearchable(t *testing.T, queries []string, engine searchEngine) {
	twg := new(sync.WaitGroup)
	for _, query := range queries {
		twg.Add(1)
		go func(query string) {
			defer twg.Done()
			for attempt, maxAttempt := 1, 5; ; attempt++ {
				out := searchWithEngines([]searchEngine{engine})(query)
				meta, ok := <-(out)
				if ok {
					t.Logf("%s -> %s %s", query, meta.Code, meta.Title)
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
	twg.Wait()
}

func assertUnsearchable(t *testing.T, queries []string, engine searchEngine) {
	twg := new(sync.WaitGroup)
	for _, query := range queries {
		twg.Add(1)
		go func(query string) {
			defer twg.Done()
			out := searchWithEngines([]searchEngine{engine})(query)
			meta, ok := <-(out)
			if ok {
				t.Fatalf("Unexpected: %s -> %+v", query, meta)
			}
		}(query)
	}
	twg.Wait()
}
