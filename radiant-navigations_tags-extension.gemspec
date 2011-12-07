# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-navigation_tags-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-navigation_tags-extension"
  s.version     = RadiantNavigationTagsExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantNavigationTagsExtension::AUTHORS
  s.email       = RadiantNavigationTagsExtension::EMAIL
  s.homepage    = RadiantNavigationTagsExtension::URL
  s.summary     = RadiantNavigationTagsExtension::SUMMARY
  s.description = RadiantNavigationTagsExtension::DESCRIPTION

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
