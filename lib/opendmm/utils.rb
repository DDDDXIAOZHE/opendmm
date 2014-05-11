require "active_support/core_ext/module/aliasing"
require "active_support/core_ext/numeric/time"

module OpenDMM
  module Utils
    def self.parse_dl(dl)
      dts = dl.css("dt").map(&:text)
      dds = dl.css("dd")
      Hash[dts.zip(dds)]
    end

    def self.utf8_html(content)
      encoding = Nokogiri::HTML(content).encoding
      content = content.encode('UTF-8', encoding, invalid: :replace, undef: :replace, replace: '')
      Nokogiri::HTML(content)
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
