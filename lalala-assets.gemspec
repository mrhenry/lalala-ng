# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lalala/version'

Gem::Specification.new do |gem|
  gem.name          = "lalala-assets"
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
  gem.add_runtime_dependency 'coffee-rails',         '= 3.2.2'
  gem.add_runtime_dependency 'coffee-script-source', '= 1.4.0'
  gem.add_runtime_dependency 'compass',              '= 0.13.alpha.0'
  gem.add_runtime_dependency 'compass-rails',        '= 1.0.3'
  gem.add_runtime_dependency 'sass',                 '= 3.2.7'
  gem.add_runtime_dependency 'sass-rails',           '= 3.2.6'
  gem.add_runtime_dependency 'sprockets-commonjs',   '= 0.0.5'
  gem.add_runtime_dependency 'uglifier',             '= 1.3.0'

end
