module Lalala
  module Generators
    class AssetsGenerator < Rails::Generators::Base

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def install_assets
        require 'rails'
        require 'active_admin'

        template 'active_admin.js', 'app/assets/javascripts/active_admin.js'
        template 'active_admin.css.scss', 'app/assets/stylesheets/active_admin.css.scss'
      end

      def add_humans_txt
        copy_file "humans.txt", "public/humans.txt"
      end
    end
  end
end
