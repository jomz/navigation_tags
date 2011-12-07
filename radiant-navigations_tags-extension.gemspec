# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "navigation_tags_extension"

Gem::Specification.new do |s|
  s.name        = "radiant-navigation_tags-extension"
  s.version     = NavigationTagsExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = NavigationTagsExtension::AUTHORS
  s.email       = NavigationTagsExtension::EMAIL
  s.homepage    = NavigationTagsExtension::URL
  s.summary     = NavigationTagsExtension::SUMMARY
  s.description = NavigationTagsExtension::DESCRIPTION

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]
end
