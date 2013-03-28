class AppBuilder < Rails::AppBuilder
  include Thor::Actions
  include Thor::Shell

  RUBY_VERSION = "2.0.0"

  def gemfile
    create_file 'Gemfile', <<-DOC
source 'https://rubygems.org'

ruby "#{RUBY_VERSION}"

git 'git://github.com/mrhenry/lalala-ng', submodules: true do
  gem 'lalala'
  gem 'lalala-development', groups: [:development]
  gem 'lalala-assets',      groups: [:development, :assets]
  gem 'lalala-test',        groups: [:test]
end
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
