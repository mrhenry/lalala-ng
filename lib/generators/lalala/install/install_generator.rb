require 'rails/generators/active_record'
require 'securerandom'

module Lalala
  module Generators

    # This class is stolen from active admin
    class InstallGenerator < ::ActiveRecord::Generators::Base

      desc "Installs Active Admin and generates the necessary migrations"
      argument :name, :type => :string, :default => "AdminUser"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer_devise
        template 'devise.rb.erb', 'config/initializers/devise.rb'
      end

      def setup_routes
        remove_file("config/routes.rb")
        template 'routes.rb.erb', 'config/routes.rb'
      end

      def copy_initializer_active_admin
        @underscored_user_name = name.underscore
        template 'active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def setup_errors
        empty_directory "app/controllers"
        template 'errors_controller.rb', 'app/controllers/errors_controller.rb'
      end

      def setup_models
        empty_directory "app/models"
      end

      def setup_admin_users
        empty_directory "app/models"
        template 'models/admin_user.rb', 'app/models/admin_user.rb'
        empty_directory "app/admin"
        template 'admin_users.rb', 'app/admin/admin_users.rb'
      end

      def setup_pages
        empty_directory "app/pages"
        template 'models/application_page.rb', 'app/pages/application_page.rb'
        empty_directory "app/controllers"
        template 'pages_controller.rb', 'app/controllers/pages_controller.rb'
        empty_directory "app/admin"
        template 'admin_pages.rb', 'app/admin/admin_pages.rb'
      end

      def setup_directory
        empty_directory "app/admin"
        template 'dashboard.rb', 'app/admin/dashboard.rb'
      end

      def setup_environment_configs
        template "staging.rb.erb", "config/environments/staging.rb"
        gsub_file "config/environments/production.rb", "  # config.assets.precompile += %w( search.js )", "  config.assets.precompile += %w( modernizr.js )"
      end

      def setup_helpers
        empty_directory "app/helpers"
        copy_file "helpers/application_helper.rb", "app/helpers/application_helper.rb"
        template "helpers/open_graph_helper.rb.erb", "app/helpers/open_graph_helper.rb"
        copy_file "helpers/html_helper.rb", "app/helpers/html_helper.rb"
        copy_file "helpers/pages_helper.rb", "app/helpers/pages_helper.rb"
      end

      def setup_locales
        empty_directory 'config/locales'
        copy_file 'locales/en.yml', 'config/locales/en.yml'
      end

      def setup_forklift
        empty_directory ".forklift"
      end

      def copy_default_mailer_layout
        copy_file 'application_mailer.html.erb', 'app/views/layouts/application_mailer.html.erb'
      end

      def create_assets
        generate "lalala:assets"
      end

    end
  end
end
