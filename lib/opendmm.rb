require 'opendmm/version'
require 'opendmm/maker'
require 'opendmm/search_engines/jav_library'

module OpenDMM
  def self.search(name)
    details = Maker.search(name) || SearchEngine::JavLibrary.search(name)
    return nil unless details
    details = details.squish_hard
    if !details[:cover_image].start_with?('http')
      details[:cover_image] = URI.join(details[:page], details[:cover_image]).to_s
    end
    if !details[:thumbnail_image].start_with?('http')
      details[:thumbnail_image] = URI.join(details[:page], details[:thumbnail_image]).to_s
    end
    if details[:sample_images]
      details[:sample_images] = details[:sample_images].map do |uri|
        uri.start_with?('http') ? uri : URI.join(details[:page], uri).to_s
      end
    end
    if details[:movie_length].instance_of? String
      details[:movie_length] = ChronicDuration.parse(details[:movie_length])
    end
    if details[:release_date].instance_of? String
      details[:release_date] = Date.parse(details[:release_date])
    end
    details
  end
end