require 'opendmm/version'
require 'opendmm/maker'
require 'opendmm/search_engine'

module OpenDMM
  # Known fields:
  #
  # {
  #   actresses:        Array
  #   actress_types:    Array
  #   boobs:            String
  #   brand:            String
  #   categories:       Array
  #   code:             String
  #   cover_image:      String
  #   description:      String
  #   directors:        Array
  #   genres:           Array
  #   label:            String
  #   maker:            String
  #   movie_length:     Fixnum
  #   page:             String
  #   release_date:     Date
  #   sample_images:    Array
  #   scatologies:      Array
  #   scenes:           Array
  #   series:           String
  #   subtitle:         String
  #   theme:            String
  #   thumbnail_image:  String
  #   title:            String
  #   transsexualities: Array
  # }

  def self.search(name, debug = false)
    [ Maker,
      SearchEngine::JavLibrary,
      SearchEngine::Dmm,
      SearchEngine::Mgstage,
      SearchEngine::AvEntertainments ].each do |engine|
      begin
        result = engine.search(name)
        return result if result
      rescue => e
        if debug
          puts e.inspect
          puts e.backtrace.join("\n")
          return nil
        end
      end
    end
    nil
  end
end