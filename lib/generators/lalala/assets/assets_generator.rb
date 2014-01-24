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

      def setup_bower
        copy_file ".bowerrc", ".bowerrc"
        template "bower.json.erb", "app/assets/bower.json"

        gsub_file "config/application.rb", /    config.assets.version = '1.0'/, <<-HEREDOC
    config.assets.version = '1.0'

    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
HEREDOC

        append_file(".gitignore", <<-HEREDOC
/public/uploads
.DS_Store
HEREDOC
      )
      end

      def setup_javascripts
        remove_file "app/assets/javascripts/application.js"
        copy_file "application.js", "app/assets/javascripts/application.js"
        empty_directory "app/assets/javascripts/modules"
        copy_file "initializer.module.js", "app/assets/javascripts/modules/initializer.module.js"
        copy_file "hello-world.module.js", "app/assets/javascripts/modules/hello-world.module.js"
      end

      def setup_stylesheets
        remove_file "app/assets/stylesheets/application.css"
        copy_file "application.css.scss", "app/assets/stylesheets/application.css.scss"
        empty_directory "app/assets/stylesheets/base"
        empty_directory "app/assets/stylesheets/modules"

        copy_file "_variables.css.scss", "app/assets/stylesheets/base/_variables.css.scss"
        copy_file "_mixins.css.scss", "app/assets/stylesheets/base/_mixins.css.scss"
        copy_file "_keyframes.css.scss", "app/assets/stylesheets/base/_keyframes.css.scss"
        create_file "app/assets/stylesheets/base/_fonts.css.scss"
        create_file "app/assets/stylesheets/base/_base.css.scss"
      end

      def add_humans_txt
        copy_file "humans.txt", "public/humans.txt"
      end

      def run_bower
        run('bower install')
      end

    end
  end
end
