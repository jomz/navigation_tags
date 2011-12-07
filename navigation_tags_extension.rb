require "radiant-navigation_tags-extension"
class NavigationTagsExtension < Radiant::Extension
  version     RadiantNavigationTagsExtension::VERSION
  description RadiantNavigationTagsExtension::DESCRIPTION
  url         RadiantNavigationTagsExtension::URL
    
  def activate
    Page.send :include, NavigationTags
  end
  
end