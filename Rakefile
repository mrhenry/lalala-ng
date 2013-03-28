begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end



begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Lalala'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end



APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'



namespace 'lalala' do
  Bundler::GemHelper.install_tasks name: 'lalala'
end

namespace 'lalala-development' do
  Bundler::GemHelper.install_tasks name: 'lalala-development'
end

namespace 'lalala-assets' do
  Bundler::GemHelper.install_tasks name: 'lalala-assets'
end

namespace 'lalala-test' do
  Bundler::GemHelper.install_tasks name: 'lalala-test'
end



require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :test => 'app:db:test:load'



task :default => :test
