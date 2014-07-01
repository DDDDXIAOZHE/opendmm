require 'active_support/core_ext/array/access'
require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/module/aliasing'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/filters'
require 'active_support/core_ext/string/starts_ends_with'
require 'chronic_duration'
require 'nokogiri'

class << Date
  def parse_with_chinese_support(str)
    case str
    when /(\d{4})年(\d{1,2})月(\d{1,2})日/
      return new($1.to_i, $2.to_i, $3.to_i)
    when /(\d{2})年(\d{1,2})月(\d{1,2})日/
      year = 2000 + $1.to_i
      year -= 100 if year > Date.today.year
      return new(year, $2.to_i, $3.to_i)
    else
      return parse_without_chinese_support(str)
    end
  end
  alias_method_chain :parse, :chinese_support
end

class << ChronicDuration
  def parse_with_chinese_support(str)
    case str
    when /(\d+)(\s*)分/
      return $1.to_i.minutes
    else
      return parse_without_chinese_support(str)
    end
  end
  alias_method_chain :parse, :chinese_support
end

class NilClass
  def text
    ''
  end
end

module OpenDMM
  module Utils
    def self.hash_from_dl(dl)
      dts = dl.css('dt').map(&:text).map(&:squish)
      dds = dl.children.select do |node|
        node.name == 'dt' || node.name == 'dd'
      end.split do |node|
        node.name == 'dt'
      end[1..-1].map do |nodes|
        node_set = Nokogiri::XML::NodeSet.new(dl.document)
        nodes.each do |node|
          node_set << node
        end
        node_set
      end
      Hash[dts.zip(dds)]
    end

    def self.hash_by_split(array, delimiter = /[：:]/)
      array.map do |str|
        slices = str.split(delimiter, 2).map(&:squish)
      end.select do |pair|
        pair.size == 2
      end.to_h
    end

    def self.html_in_utf8(content)
      encoding = Nokogiri.HTML(content).encoding
      content = content.encode('UTF-8', encoding, invalid: :replace, undef: :replace, replace: '')
      Nokogiri.HTML content
    end

    def self.finalize_details_hash(details)
      details = details.squish_hard
      details[:cover_image] = join_url_if_relative(details[:page], details[:cover_image])
      details[:thumbnail_image] = join_url_if_relative(details[:page], details[:thumbnail_image])
      details[:sample_images] = details[:sample_images].map do |uri|
        join_url_if_relative(details[:page], uri)
      end if details[:sample_images]
      details[:movie_length] = ChronicDuration.parse(details[:movie_length]) if details[:movie_length]
      details[:release_date] = Date.parse(details[:release_date]) if details[:release_date]
      details.sort.to_h
    end

    def self.join_url_if_relative(page_url, image_url)
      return nil unless image_url
      image_url.start_with?('http') ? image_url : URI.join(page_url, image_url).to_s
    end
  end
end

class Object
  def squish_hard
    presence
  end
end

class String
  def squish_hard
    squish.gsub(/^[\s-]*$/, '').presence
  end
end

class Hash
  def squish_hard
    map do |k, v|
      [k, v.squish_hard]
    end.select do |k_v|
      k_v.second.present?
    end.to_h.presence
  end
end

class Array
  def squish_hard
    map(&:squish_hard).select(&:present?).presence
  end
end
