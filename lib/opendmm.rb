require 'opendmm/version'
require 'opendmm/maker'
require 'opendmm/search_engines/jav_library'
require 'opendmm/search_engines/dmm'

module OpenDMM
  def self.search!(name)
    details = Maker.search(name) ||
              SearchEngine::JavLibrary.search(name) ||
              SearchEngine::Dmm.search(name)
    return nil unless details
    details = details.squish_hard
    details[:cover_image] = join_if_relative(details[:page], details[:cover_image])
    details[:thumbnail_image] = join_if_relative(details[:page], details[:thumbnail_image])
    details[:sample_images] = details[:sample_images].map do |uri|
      join_if_relative(details[:page], uri)
    end if details[:sample_images]
    details[:movie_length] = ChronicDuration.parse(details[:movie_length]) if details[:movie_length]
    details[:release_date] = Date.parse(details[:release_date]) if details[:release_date]
    details
  end

  def self.search(name)
    search! name
  rescue
    nil
  end

private
  def self.join_if_relative(page_url, image_url)
    return nil unless image_url
    image_url.start_with?('http') ? image_url : URI.join(page_url, image_url).to_s
  end
end