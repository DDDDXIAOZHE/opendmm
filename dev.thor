require 'active_support/core_ext/string/inflections'

class Dev < Thor
  include Thor::Actions

  argument :name

  def self.source_root
    File.dirname(__FILE__)
  end

  desc 'engine', 'generate a engine'
  def engine
    puts "generate engine"
    template('templates/engine.tt', "lib/opendmm/engines/#{name.underscore}.rb")
  end
end