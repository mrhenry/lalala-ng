class AppBuilder < Rails::AppBuilder
  include Thor::Actions
  include Thor::Shell

  RUBY_VERSION   = "2.1.0"
  LALALA_VERSION = "4.1.0.dev"

  def gemfile
    create_file 'Gemfile', <<-DOC

source 'https://rubygems.org'

ruby "#{RUBY_VERSION}"

gem 'lalala',             "~> #{LALALA_VERSION}"
gem 'lalala-development', "~> #{LALALA_VERSION}", groups: [:development]
gem 'lalala-assets',      "~> #{LALALA_VERSION}", groups: [:development, :assets]
gem 'lalala-test',        "~> #{LALALA_VERSION}", groups: [:test]

DOC
  end

  def ruby_version
    create_file ".ruby-version", RUBY_VERSION
  end

  def leftovers
    ruby_version
  end

end

class Rails::Generators::AppGenerator

  alias_method :lng_run_bundle, :run_bundle

  def run_bundle
    lng_run_bundle
    generate "lalala:install"
  end

end
