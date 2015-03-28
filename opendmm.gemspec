lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opendmm/version'

Gem::Specification.new do |spec|
  spec.name          = 'opendmm'
  spec.version       = OpenDMM::VERSION
  spec.authors       = ['Jun Zhou']
  spec.email         = ['pinepara@gmail.com']
  spec.summary       = 'OpenDMM: an open-source Japanese AV search engine'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.lines.map(&:chomp)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'hashdiff'
  spec.add_development_dependency 'highline'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'thor'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'chronic_duration'
  spec.add_dependency 'httparty'
  spec.add_dependency 'nokogiri'
end
