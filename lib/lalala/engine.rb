module Lalala
  class Engine < Rails::Engine

    config.i18n.fallbacks = true
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en]

    config.lalala = ActiveSupport::OrderedOptions.new
    config.lalala.i18n = ActiveSupport::OrderedOptions.new
    config.lalala.i18n.adapter = nil

    initializer "lalala.error_handlers" do |app|
      app.config.exceptions_app = app.routes
    end

    initializer "lalala.active_admin.load_path" do
      ActiveAdmin.application.load_paths.unshift File.expand_path('../admin', __FILE__)
    end

    initializer "lalala.i18n.adapter" do |app|
      adapter   = app.config.lalala.i18n.adapter
      adapter ||= Lalala::ExtI18n::NegotiationAdapter.new
      app.config.lalala.i18n.adapter = adapter
    end

    initializer "lalala.middleware" do |app|
      stack = app.middleware

      stack.insert_before(
        'ActionDispatch::Flash',
        Lalala::ExtRack::CanonicalURL)

      stack.insert_before(
        'ActionDispatch::Flash',
        Lalala::ExtRack::I18nNegotiator,
        app.config.lalala.i18n.adapter)

      stack.insert_before(
        'ActionDispatch::Flash',
        Lalala::ExtRack::PageLoader)

    end

  end

  Formtastic::FormBuilder.send(
    :include, Lalala::ExtI18n::InputHelper)

  ActiveSupport.on_load :active_record do

    ActiveRecord::ConnectionAdapters::AbstractAdapter.send(
      :include, Lalala::ExtActiveRecord::Schema::JoinTable)

    ActiveRecord::Migration::CommandRecorder.send(
      :include, Lalala::ExtActiveRecord::Schema::JoinTableInverter)

    ActiveRecord::Base.send(
      :include, Lalala::ExtActiveRecord::I18nTranslationsWriter)

  end

  ActiveSupport.on_load :action_controller do
    ActionDispatch::Routing::Mapper.send :include, Lalala::Pages::RouteMapper
  end

end
