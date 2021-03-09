# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'indoor_jungle/version'

Gem::Specification.new do |spec|
  spec.name          = "personal_indoor_jungle_builder"
  spec.version       = IndoorJungle::Version
  spec.authors       = ["shamitomita"]
  spec.email         = ["shamitomita@gmail.com.com"]

  spec.summary       = %q{Plant Scraper}
  spec.description   = %q{Enter user information to receive a list of suitable plants from Plants.com}
  spec.homepage      = "https://github.com/ShamiTomita/Personal-Indoor-Jungle-Builder"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry", "~> 0.14.0"

  spec.add_dependency "open-uri", "~> 0.1.0"
  spec.add_dependency "colorize", "~> 0.8.1"
  spec.add_dependency "nokogiri"
end
