# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blitzcrank/version'

Gem::Specification.new do |spec|
  spec.name          = "blitzcrank"
  spec.version       = Blitzcrank::VERSION
  spec.authors       = ["pyro2927"]
  spec.email         = ["joseph@pintozzi.com"]
  spec.description   = "Copy down remote files and sort into nice folders"
  spec.summary       = "Uhhh.... torrent management gem?"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~>10.4"

  spec.add_dependency("colorize", "0.6.0")
  spec.add_dependency("imdb", "0.8.0")
  spec.add_dependency("ruby-configurable", "1.0.2")
  spec.add_dependency("rsync", "1.0.9")

end
