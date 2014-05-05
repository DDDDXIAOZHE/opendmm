require "active_support/core_ext/module/aliasing"

module OpenDMM
  module Utils
    def self.parse_dl(dl)
      dts = dl.css("dt").map(&:text)
      dds = dl.css("dd")
      Hash[dts.zip(dds)]
    end
  end
end

class << Date
  def parse_with_chinese_support(str)
    case str
    when /(\d{4})年(\d{2})月(\d{2})日/
      return new($1.to_i, $2.to_i, $3.to_i)
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
