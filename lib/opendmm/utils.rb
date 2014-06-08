require "active_support/core_ext/module/aliasing"
require "active_support/core_ext/numeric/time"

module OpenDMM
  module Utils
    def self.hash_from_dl(dl)
      dts = dl.css("dt").map(&:text)
      dds = dl.css("dd")
      Hash[dts.zip(dds)]
    end

    def self.hash_by_split(array, delimiter = /[：:]/)
      array.map do |str|
        slices = str.split(delimiter, 2).map(&:squish)
      end.select do |pair|
        pair.size == 2
      end.to_h
    end

    def self.force_utf8(content)
      # This is to get rid of the annoying error message:
      #   "encoding error : input conversion failed due to input error"
      $stderr.reopen("/dev/null", "w")
      encoding = Nokogiri::HTML(content).encoding
      $stderr = STDERR
      content = content.encode('UTF-8', encoding, invalid: :replace, undef: :replace, replace: "")
    end
  end
end

class << Date
  def parse_with_chinese_support(str)
    case str
    when /(\d{4})年(\d{1,2})月(\d{1,2})日/
      return new($1.to_i, $2.to_i, $3.to_i)
    else
      return parse_without_chinese_support(str)
    end
  end
  alias_method_chain :parse, :chinese_support
end

class << ChronicDuration
  def parse_with_chinese_support(str)
    case str
    when /(\d+)分/
      return $1.to_i.minutes
    else
      return parse_without_chinese_support(str)
    end
  end
  alias_method_chain :parse, :chinese_support
end

class NilClass
  def text
    ""
  end

  def split(pattern = $;, limit = 0)
    nil
  end
end

class Hash
  def self.new_with_keys(array)
    self.new.tap do |hash|
      array.each do |item|
        hash[item] = nil
      end
    end
  end
end

class String
  def discard_if_empty
    self.squish.match(/-+/) ? nil : self.squish
  end
end