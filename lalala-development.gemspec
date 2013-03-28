# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lalala/version'

Gem::Specification.new do |gem|
  gem.name          = "lalala-development"
  gem.version       = Lalala::VERSION

  gem.authors       = [
    "Simon Menke",
    "Yves Van Broekhoven",
    "Steven Vandevelde",
    "Hans Spooren",
    "Inge Reulens",
    "Simon Pertz"
  ]

  gem.email         = ["hello@mrhenry.be"]
  gem.description   = %q{Lalala: Probably the best CMS in the world}
  gem.summary       = %q{Lalala: Probably the best CMS in the world.}
  gem.homepage      = "http://mrhenry.be"

  gem.files         = []
  gem.executables   = []
  gem.test_files    = []
  gem.require_paths = ["lib"]

  # generic
  gem.add_runtime_dependency 'lalala',               Lalala::VERSION
  gem.add_runtime_dependency 'lalala-assets',        Lalala::VERSION
  gem.add_runtime_dependency 'pry-rails',            '> 0'

end
