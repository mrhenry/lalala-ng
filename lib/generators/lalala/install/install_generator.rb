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
        copy_file "models/file_asset.rb", "app/models/file_asset.rb"
        copy_file "models/image_asset.rb", "app/models/image_asset.rb"
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

      def setup_uploaders
        empty_directory "app/uploaders"
        copy_file "uploaders/file_uploader.rb", "app/uploaders/file_uploader.rb"
        copy_file "uploaders/image_uploader.rb", "app/uploaders/image_uploader.rb"
      end

      def setup_environment_configs
        template "staging.rb.erb", "config/environments/staging.rb"
        gsub_file "config/environments/production.rb", "  # config.assets.precompile += %w( search.js )", "  config.assets.precompile += %w( modernizr.js )"
      end

      def setup_forklift
        empty_directory ".forklift"
      end

      def copy_default_mailer_layout
        copy_file 'application_mailer.html.erb', 'app/views/layouts/application_mailer.html.erb'
      end

      def copy_default_layout
        copy_file 'application.html.erb', 'app/views/layouts/application.html.erb'
      end

      def create_assets
        generate "lalala:assets"
      end

    end
  end
end
