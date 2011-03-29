class NavigationTagsExtension < Radiant::Extension
  version "2.1"
  description "Makes building navigations much easier."
  url "https://github.com/jomz/navigation_tags"
    
  def activate
    Page.send :include, NavigationTags
  end
  
end