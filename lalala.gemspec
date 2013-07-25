# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lalala/version'

Gem::Specification.new do |gem|
  gem.name          = "lalala"
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

  gem.files = `git ls-files`.split($/).reject{ |f| /^vendor\/deps/ === f }

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  # generic
  gem.add_runtime_dependency 'activeadmin',               '= 0.6.0'
  gem.add_runtime_dependency 'carrierwave',               '= 0.8.0'
  gem.add_runtime_dependency 'closure_tree',              '= 3.10.2'
  gem.add_runtime_dependency 'country-select',            '= 1.1.1'
  gem.add_runtime_dependency 'dalli',                     '= 2.6.3'
  gem.add_runtime_dependency 'fog',                       '= 1.10.0'
  gem.add_runtime_dependency 'globalize3',                '= 0.3.0'
  gem.add_runtime_dependency 'i18n-country-translations', '= 0.0.9'
  gem.add_runtime_dependency 'jquery-rails',              '= 2.2.1'
  gem.add_runtime_dependency 'meta_search',               '= 1.1.3'
  gem.add_runtime_dependency 'mini_magick',               '= 3.6.0'
  gem.add_runtime_dependency 'pg',                        '= 0.15.1'
  gem.add_runtime_dependency 'puma',                      '= 2.0.1'
  gem.add_runtime_dependency 'rails',                     '= 3.2.13'
  gem.add_runtime_dependency 'rails-i18n',                '= 0.7.3'
  gem.add_runtime_dependency 'redcarpet',                 '= 2.3.0'
  gem.add_runtime_dependency 'stringex',                  '= 1.5.1'

end
