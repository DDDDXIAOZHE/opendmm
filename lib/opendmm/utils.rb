module OpenDMM
  module Utils
    def self.parse_dl(dl)
      dts = dl.css("dt").map(&:text)
      dds = dl.css("dd")
      Hash[dts.zip(dds)]
    end
  end
end