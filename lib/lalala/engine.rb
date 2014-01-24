module Lalala
  require 'lalala'

  class Engine < Rails::Engine

    config.i18n.fallbacks = true
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en]
    config.i18n.enforce_available_locales = true
    I18n.enforce_available_locales = true

    config.lalala = ActiveSupport::OrderedOptions.new
    config.lalala.i18n = ActiveSupport::OrderedOptions.new
    config.lalala.i18n.adapter = nil

    initializer "lalala.migrations" do |app|
      app.class.configure do
        unless defined?(CALLED_FROM_ENGINE) and CALLED_FROM_ENGINE
          config.paths['db/migrate'] += Lalala::Engine.paths['db/migrate'].existent
        end
      end
    end

    initializer "lalala.threadsafe" do |app|
      unless Rails.env.development? or Rails.env.test? or defined?(::Rake)
        app.config.threadsafe!
      end
    end

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

    initializer "lalala.assets", :group => :assets do |app|
      ::Sass::Engine::DEFAULT_OPTIONS[:load_paths] << File.expand_path("../../../app/assets/stylesheets", __FILE__)
      app.config.assets.precompile += %w( lalala/editor-preview.css )
    end

    initializer "lalala.cache", before: :initialize_cache do |app|
      servers  = []
      username = nil
      password = nil

      if ENV['MEMCACHIER_SERVERS']
        servers  = ENV['MEMCACHIER_SERVERS'].split(',')
        username = ENV['MEMCACHIER_USERNAME']
        password = ENV['MEMCACHIER_PASSWORD']
      end

      if ENV['BOXEN_MEMCACHED_URL']
        url = URI.parse(ENV['BOXEN_MEMCACHED_URL'])
        servers << "#{url.host}:#{url.port}"
      end

      Lalala::Cache.setup!(app, servers, username, password)
    end

  end


  if defined?(I18n)
    I18n.send(
      :extend, Lalala::ExtI18n::LocaleSource)
  end

  ActiveSupport.on_load :active_record do
    Lalala::ExtWithAdvisoryLock.patch!
  end

  if defined?(Formtastic)
    Formtastic::FormBuilder.send(
      :include, Lalala::Markdown::InputHelper)

    Formtastic::FormBuilder.send(
      :include, Lalala::ExtI18n::InputHelper)
  end

  ActiveSupport.on_load :active_record do

    ActiveRecord::ConnectionAdapters::AbstractAdapter.send(
      :include, Lalala::ExtActiveRecord::Schema::JoinTable)

    ActiveRecord::Migration::CommandRecorder.send(
      :include, Lalala::ExtActiveRecord::Schema::JoinTableInverter)

    ActiveRecord::Base.send(
      :include, Lalala::ExtActiveRecord::I18nTranslationsWriter)

  end

  ActiveSupport.on_load :action_controller do

    ActionDispatch::Routing::Mapper.send(
      :include, Lalala::Pages::RouteMapper)

    ActionDispatch::Request.send(
      :include, Lalala::ExtActionDispatch::MultiFileUpload)

    ActionDispatch::Request.send(
      :include, Lalala::ExtActionDispatch::PageName)

    ActionController::Base.send(
      :include, Lalala::Pages::Helpers)

  end

end
