require "navigation_tags_extension"
class NavigationTagsExtension < Radiant::Extension
  version     NavigationTagsExtension::VERSION
  description NavigationTagsExtension::DESCRIPTION
  url         NavigationTagsExtension::URL
    
  def activate
    Page.send :include, NavigationTags
  end
  
end