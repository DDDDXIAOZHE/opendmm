package opendmm

import (
	"sync"
)

// MovieMeta contains meta data of movie
type MovieMeta struct {
	Actresses      []string
	ActressTypes   []string
	Categories     []string
	Code           string
	CoverImage     string
	Description    string
	Directors      []string
	Genres         []string
	Label          string
	Maker          string
	MovieLength    string
	Page           string
	ReleaseDate    string
	SampleImages   []string
	Series         string
	Tags           []string
	ThumbnailImage string
	Title          string
}

// Guess possible movie codes from query string
func Guess(query string) []string {
	variationMap := make(map[string]bool)
	codes := guessCodes(query)
	for code := range codes {
		for variation := range code.variations() {
			variationMap[variation] = true
		}
	}
	variations := make([]string, 0, len(variationMap))
	for variation := range variationMap {
		variations = append(variations, variation)
	}
	return variations
}

type searchEngine func(string, *sync.WaitGroup, chan MovieMeta)

func searchWithEngines(engines []searchEngine) func(string) chan MovieMeta {
	return func(query string) chan MovieMeta {
		variations := Guess(query)
		out := make(chan MovieMeta, 100)
		wg := new(sync.WaitGroup)
		for _, engine := range engines {
			for _, variation := range variations {
				wg.Add(1)
				go func(engine searchEngine, variation string, wg *sync.WaitGroup, out chan MovieMeta) {
					defer wg.Done()
					engine(variation, wg, out)
				}(engine, variation, wg, out)
			}
		}
		go func(wg *sync.WaitGroup, out chan MovieMeta) {
			wg.Wait()
			close(out)
		}(wg, out)
		return postProcess(out)
	}
}

// Search is the default search func with all engines
var Search = searchWithEngines([]searchEngine{
	aveEngine,
	deepsEngine,
	dmmEngine,
	mgsEngine,
})
