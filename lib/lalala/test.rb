module Lalala
  module Test

    def self.setup!
      require 'capybara/rails'
      require 'capybara/poltergeist'

      Rails.backtrace_cleaner.remove_silencers!

      ActionDispatch::IntegrationTest.send :include, Capybara::DSL

      Capybara.javascript_driver = :poltergeist

      I18n.reload!
    end

  end
end
