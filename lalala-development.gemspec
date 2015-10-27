# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lalala/version'

Gem::Specification.new do |gem|
  gem.name          = "lalala-development"
  gem.version       = Lalala::BUILD_VERSION
  gem.license       = 'MIT'

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
  gem.add_runtime_dependency 'lalala',               Lalala::BUILD_VERSION
  gem.add_runtime_dependency 'lalala-assets',        Lalala::BUILD_VERSION
  gem.add_runtime_dependency 'pry-rails',            '> 0'
  gem.add_runtime_dependency 'sqlite3',              '> 1'

end
