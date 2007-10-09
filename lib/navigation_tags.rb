module NavigationTags
  include Radiant::Taggable
  
  desc "Render a navigation menu. Walks down the directory tree, expanding the tree up to the current page."
  tag "nav" do |tag|
    root = Page.find_by_url(tag.attr['root'] || '/')
    depth = tag.attr['depth'] || 1
    include_root = tag.attr['include_root'] || false
    tree = include_root ? %{<li#{" class=\"current\"" if tag.locals.page == root}><a href="#{root.url}">#{root.breadcrumb}</a></li>} : ""
    for child in root.children
      tree << tag.render('sub-nav', {:page => child, :depth => depth.to_i - 1 })
    end
    %{<ul>#{tree}</ul>}
  end
  
  tag "sub-nav" do |tag|
    current_page = tag.locals.page
    child_page = tag.attr[:page]
    return if child_page.part("no-map") or child_page.virtual? or !child_page.published?
    css_class = [("current" if current_page == child_page), ("has_children" if child_page.children.size > 0)].compact
    r = %{<li#{" class=\"#{css_class.join(" ")}\"" unless css_class.empty?}><a href="#{child_page.url}">#{child_page.breadcrumb}</a>}
    published_children = child_page.children.delete_if{|c| c.part("no-map") }
    if published_children.size > 0 and current_page.url.starts_with?(child_page.url) and tag.attr[:depth].to_i > 0
      r << "<ul>"
      child_page.children.each do |child|
        r << tag.render('sub-nav', :page => child, :depth => tag.attr[:depth].to_i )
      end
      r << "</ul>"
    end
    r << "</li>"
  end
  
  
  # Inspired by this thread: 
  # http://www.mail-archive.com/radiant@lists.radiantcms.org/msg03234.html
  # Author: Marty Haught
  desc %{
    Renders the contained element if the current item is an ancestor of the current page or if it is the page itself. 
  }
  tag "if_ancestor_or_self" do |tag|
    Page.benchmark "TAG: if_ancestor_or_self - #{tag.locals.page.url}" do
      tag.expand if tag.globals.actual_page.url.starts_with?(tag.locals.page.url)
    end
  end
  
  desc %{
    Renders the contained element if the current item is also the current page. 
  }
  tag "if_self" do |tag|
    Page.benchmark "TAG: if_self - #{tag.locals.page.url}" do
      tag.expand if tag.locals.page == tag.globals.actual_page
    end
  end
  
  desc %{    
    Renders the contained elements only if the current contextual page has children.
    
    *Usage:*
    <pre><code><r:if_children>...</r:if_children></code></pre>
  }
  tag "if_children" do |tag|
    Page.benchmark "TAG: if_children - #{tag.locals.page.url}" do
      tag.expand if tag.locals.page.children.size > 0
    end
  end
  
  tag "unless_children" do |tag|
    tag.expand unless tag.locals.page.children.size > 0
  end
  
  tag "benchmark" do |tag|
    Page.benchmark "BENCHMARK: #{tag.attr['name']}"do
      tag.expand
    end
  end
  
end