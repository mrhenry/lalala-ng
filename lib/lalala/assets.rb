require 'lalala'

module Lalala

  require 'sass'
  require 'sass-rails'
  require 'compass-rails'

  require 'coffee_script/source'
  require 'coffee-rails'
  require 'sprockets/commonjs'

  require 'uglifier'

end


module Lalala::Assets
  extend ActiveSupport::Autoload

  autoload :List
end
