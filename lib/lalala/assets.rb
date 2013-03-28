require 'lalala'

module Lalala

  require 'sass'
  require 'sass-rails'
  require 'compass-rails'

  require 'coffee_script/source'
  require 'coffee-rails'
  require 'sprockets/commonjs'

  require 'uglifier'

  ::Sass::Engine::DEFAULT_OPTIONS[:load_paths] << File.expand_path("../../../app/assets/stylesheets", __FILE__)

end
