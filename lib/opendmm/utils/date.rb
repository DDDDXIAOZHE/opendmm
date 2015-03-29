module OpenDMM
  module Date
    def self.parse(str)
      case str
      when /(\d{4})年(\d{1,2})月(\d{1,2})日/
        ::Date.new($1.to_i, $2.to_i, $3.to_i)
      when /(\d{2})年(\d{1,2})月(\d{1,2})日/
        year = 2000 + $1.to_i
        year -= 100 if year > Date.today.year
        ::Date.new(year, $2.to_i, $3.to_i)
      else
        ::Date.parse(str)
      end
    rescue ArgumentError => e
      ::Date._strptime(str, '%m-%d-%Y') ||
      ::Date._strptime(str, '%m/%d/%Y')
    end
  end
end