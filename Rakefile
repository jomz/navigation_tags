require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the navigation_tags extension.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the navigation_tags extension.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'NavigationTagsExtension'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Load any custom rakefiles for extension
Dir[File.dirname(__FILE__) + '/tasks/*.rake'].sort.each { |f| require f }

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "radiant-navigation_tags-extension"
    gem.summary = %Q{Navigation tags extension for Radiant CMS}
    gem.description = %Q{Adds r:nav, a versatile navigation building tag to Radiant CMS}
    gem.email = "benny@gorilla-webdesign.be"
    gem.homepage = "https://github.com/jomz/navigation_tags"
    gem.authors = ["Benny Degezelle"]
    gem.add_dependency 'radiant', ">=0.9.1"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. This is only required if you plan to package copy_move as a gem."
end