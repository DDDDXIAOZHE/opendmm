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

// Guess possible movie codes from query string, can choose to include
// variations or not.
func Guess(query string, includeVariations bool) []string {
	codes := guessCodes(query)
	res := []string{}
	dedupeMap := make(map[string]bool)
	for code := range codes {
		if includeVariations {
			for variation := range code.variations() {
				if dedupeMap[variation] {
					continue
				}
				dedupeMap[variation] = true
				res = append(res, variation)
			}
		} else {
			res = append(res, code.toString())
		}
	}
	return res
}

type searchEngine func(string, *sync.WaitGroup, chan MovieMeta)

func searchWithEngines(engines []searchEngine) func(string) chan MovieMeta {
	return func(query string) chan MovieMeta {
		variations := Guess(query, true)
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
	dmmEngine,
	kvEngine,
	mgsEngine,
})
