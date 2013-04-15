require 'lalala'

module Lalala

  require 'pry-rails'
  require 'better_errors'

  autoload :ExtBetterErrors

  Lalala::ExtBetterErrors.patch!

end

if defined?(Rails::Generators)
  Rails::Generators.hidden_namespaces << %w(
    active_admin:resource
    active_admin:install
    responders:install
    paper_trail:install
    mongoid:devise
    lalala:devise
    lalala:assets
    kaminari:config
    kaminari:views
    js:assets
    jquery:install
    formtastic:form
    formtastic:install
    devise
    devise:install
    devise:views
    coffee:assets
    active_admin:assets
    active_admin:devise
    active_admin:install
    active_admin:resource
    active_record:devise
    test_unit:controller
    test_unit:helper
    test_unit:integration
    test_unit:mailer
    test_unit:model
    test_unit:observer
    test_unit:performance
    test_unit:plugin
    test_unit:scaffold
    scss:assets
    scss:scaffold
    active_record:migration
    active_record:model
    active_record:observer
    active_record:session_migration
  )

  Rails::Generators.hidden_namespaces.flatten!
end
