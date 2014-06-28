require 'opendmm/version'
require 'opendmm/maker'
require 'opendmm/search_engine'

module OpenDMM
  # Known fields:
  #
  # {
  #   actresses:       Array
  #   actress_types:   Array
  #   boobs:           String
  #   brand:           String
  #   categories:      Array
  #   code:            String
  #   cover_image:     String
  #   description:     String
  #   directors:       Array
  #   genres:          Array
  #   label:           String
  #   maker:           String
  #   movie_length:    String
  #   page:            String
  #   release_date:    String
  #   sample_images:   Array
  #   scenes:          Array
  #   series:          String
  #   subtitle:        String
  #   theme:           String
  #   thumbnail_image: String
  #   title:           String
  #   __extra:         Hash
  # }

  def self.search(name, debug = false)
    Maker.search(name) || SearchEngine::JavLibrary.search(name) || SearchEngine::Dmm.search(name)
  rescue => e
    if debug
      puts e.inspect
      puts e.backtrace.join("\n")
    end
    nil
  end
end