module Lalala

  unless RUBY_VERSION == "2.0.0"
    raise "Lalala is only compatible with one version of ruby at a time (current: Ruby 2.0.0)"
  end

  require 'lalala/version'
  require 'lalala/vendor'

  require 'rails/all'
  extend ActiveSupport::Autoload

  groups = Rails.groups(:assets => %w(development test)).map(&:to_sym)

  Lalala::Vendor.enable('activeadmin', 'active_admin')
  Lalala::Vendor.enable('closure_tree')

  require 'rails-i18n'
  require 'i18n-country-translations'
  require 'carrierwave'
  require 'closure_tree'
  require 'globalize3'
  require 'jquery-rails'
  require 'meta_search'
  require 'mini_magick'
  require 'redcarpet'
  require 'stringex'
  require 'activeadmin'


  if groups.include?(:assets)
    require 'lalala/assets'
  end

  if groups.include?(:development)
    require 'lalala/development'
  end

  if groups.include?(:test)
    require 'lalala/test'
  end

  require 'formtastic/inputs/grid_input'
  require 'formtastic/inputs/single_file_input'

  autoload :ExtActiveRecord
  autoload :ExtRack
  autoload :ExtI18n
  autoload :ExtWithAdvisoryLock

  autoload :Markdown
  autoload :Pages
  autoload :Uploaders

  module Core
    require 'lalala/core/class_inheritable_setting'
  end

  module Views
    require 'lalala/views/tree_table_for'
    require 'lalala/views/index_as_tree_table'
    require 'lalala/views/title_bar'
  end

  require 'lalala/engine'

end
