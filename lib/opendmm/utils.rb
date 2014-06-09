require "active_support/core_ext/module/aliasing"
require "active_support/core_ext/numeric/time"

module OpenDMM
  module Utils
    def self.hash_from_dl(dl)
      dts = dl.css("dt").map(&:text).map(&:squish)
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
    ""
  end
end

class Array
  def squish
    array = []
    self.each do |v|
      v = v.squish_hard if v.instance_of? String
      array << v if v.present?
    end
    return array
  end
end

class Hash
  def squish
    hash = {}
    self.each do |k, v|
      case v
      when String
        v = v.squish
        v = nil if v =~ /^[\s-]*$/
      when Hash, Array
        v = v.squish
      end
      hash[k] = v if v.present?
    end
    hash
  end
end

class String
  def squish_hard
    self.squish =~ /^[\s-]*$/ ? nil : self.squish
  end
end
