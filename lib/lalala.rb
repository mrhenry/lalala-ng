module Lalala

  require "lalala/version"
  require "lalala/vendor"

  require 'rails/all'

  groups = Rails.groups(:assets => %w(development test)).map(&:to_sym)

  Lalala::Vendor.enable('activeadmin', 'active_admin')
  Lalala::Vendor.enable('closure_tree')

  require 'activeadmin'
  require 'carrierwave'
  require 'closure_tree'
  require 'globalize3'
  require 'jquery-rails'
  require 'meta_search'
  require 'mini_magick'
  require 'redcarpet'
  require 'stringex'

  if groups.include?(:assets)
    require 'sass'
    require 'sass-rails'
    require 'compass-rails'

    require 'coffee_script/source'
    require 'coffee-rails'
    require 'sprockets/commonjs'

    require 'uglifier'
  end

  if groups.include?(:development)
    require 'pry-rails'
  end

  require 'lalala/engine'
  require 'lalala/markdown'

  module Formtastic
    require 'lalala/formtastic/i18n_input_helper'
  end

  module Globalize
    require 'lalala/globalize/translations_writer'
  end

  module Core
    require 'lalala/core/class_inheritable_setting'
  end

  module Views
    require 'lalala/views/tree_table_for'
    require 'lalala/views/index_as_tree_table'
    require 'lalala/views/title_bar'
  end

  module Pages
    require 'lalala/pages/child_type_validator'
    require 'lalala/pages/path_handler'
  end

end
