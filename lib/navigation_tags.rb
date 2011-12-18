module NavigationTags
  include Radiant::Taggable
  include ActionView::Helpers::TagHelper

  class NavTagError < StandardError; end

  desc %{Render a navigation menu. Walks down the directory tree, expanding the tree up to the current page.

    *Usage:*
    <pre><code><r:nav [id="subnav"] [root=\"/products\"] [append_urls=\"/,/about-us/contact\"] [labels=\"/:Home,/about-us/contact:Contact us\"] [depth=\"2\"] [expand_all=\"true\"]/></code></pre> 
    *Attributes:*

    root: defaults to "/", where to start building the navigation from, you can i.e. use "/products" to build a subnav
    append_urls: urls of pages to add to the end of the navigation ul seperated by a comma
    prepend_urls: urls of pages to add to the beginning of the navigation ul seperated by a comma
    ids_for_lis: defaults to false, enable this to give each li an id (it's slug prefixed with nav_)
    ids_for_links: defaults to false, enable this to give each link an id (it's slug prefixed with nav_)

    labels: defaults to nil, use to overwrite the link text for given pages, otherwise the breadcrumb is used.
    depth: defaults to 1, which means no sub-ul's, set to 2 or more for a nested list
    expand_all: defaults to false, enable this to have all li's create sub-ul's of their children, i.o. only the currently active li
    id, class,..: go as html attributes of the outer ul
  }

  tag "nav" do |tag|
    if tag.double?
      root = Page.find_by_path(tag.expand)
    elsif defined?(Globalize2Extension) && Globalize2Extension.locales.size <= 1
      root = Page.find_by_path(root_url = tag.attr.delete('root') || "/#{I18n.locale}/")
    else
      root = Page.find_by_path(root_url = tag.attr.delete('root') || "/")
    end

    raise NavTagError, "No page found at \"#{root_url}\" to build navigation from." if root.class_name.eql?('FileNotFoundPage')

    depth = tag.attr.delete('depth') || 1
    ['ids_for_lis', 'ids_for_links', 'expand_all', 'first_set', 'prepend_urls', 'append_urls', 'labels'].each do |prop|
      eval "@#{prop} = tag.attr.delete('#{prop}') || false"
    end
    
    lis = []
    
    if @prepend_urls
      @prepend_urls.split(",").compact.each do |url|
        page = Page.find_by_path(url)
        if page.class_name != "FileNotFoundPage"
          lis << li_for_current_page_vs_navigation_item(tag.locals.page, page)
        end
      end
    end

    for child in root.children
      lis << tag.render('sub-nav', {:page => child, :depth => depth.to_i - 1, :first_set => @first_set })
    end
    
    if @append_urls
      @append_urls.split(",").compact.each do |url|
        page = Page.find_by_path(url)
        if page.class_name != "FileNotFoundPage"
          lis << li_for_current_page_vs_navigation_item(tag.locals.page, page)
        end
      end
    end

    if tag.attr
      html_options = tag.attr.stringify_keys
      tag_options = tag_options(html_options)
    else
      tag_options = nil
    end

    %{<ul#{tag_options}>
    #{lis.join}
    </ul>}

  end

  tag "sub-nav" do |tag|
    current_page = tag.locals.page
    child_page = tag.attr[:page]
    depth = tag.attr.delete(:depth)
    @first_set ||= tag.attr.delete(:first_set)
    return if depth.to_i < 0 or child_page.virtual? or !child_page.published? or child_page.class_name.eql? "FileNotFoundPage" or child_page.part("no-map")
    
    r = %{<li#{li_attrs_for_current_page_vs_navigation_item(current_page, child_page)}>
      #{link_for_page(child_page)}\n}
      # mind the open li
    rr = ""
    if child_page.children.size > 0 and 
        depth.to_i > 0 and
        child_page.class_name != 'ArchivePage' and
        (@expand_all || current_page.url.starts_with?(child_page.url) )
      @first_set = false
      child_page.children.each do |child|
        rr << tag.render('sub-nav', :page => child, :depth => depth.to_i - 1, :first_set => @first_set ) unless child.part("no-map") || !child.published?
      end
      
      r << "<ul>\n" + rr + "</ul>\n" unless rr.empty?
    end
    r << "</li>\n"
  end

  def li_attrs_for_current_page_vs_navigation_item current_page, child_page
    classes = []
    classes << "current" if current_page == child_page
    classes << "has_children" if child_page.children.size > 0
    classes << "parent_of_current" if !child_page.parent.nil? and current_page.url.starts_with?(child_page.url) and current_page != child_page
    (classes << "first" && @first_set = true) unless @first_set
    
    result = ""
    if classes.any?
      result = " class=\"#{classes.compact.join(" ")}\""
    end
    if @ids_for_lis
      result << " id=\"nav_" + child_page.slug + "\""
    end
    result
  end
  
  def li_for_current_page_vs_navigation_item current_page, child_page
    "<li#{li_attrs_for_current_page_vs_navigation_item(current_page, child_page)}>#{link_for_page(child_page)}</li>"
  end
  
  def link_for_page page
    if @ids_for_links
      "<a href=\"#{page.path}\" id=\"#{("link_" + (page.slug == "/" ? 'home' : page.slug))}\">#{label_for_page(page)}</a>"
    else
      "<a href=\"#{page.path}\">#{label_for_page(page)}</a>"
    end
  end
  
  def label_for_page page
    # labels="/:Home,/portfolio:Our work"
    if @labels && matched_label = @labels.split(',').select{|l| l.split(':').first == page.path}.first.try(:split, ':').try(:last)
      escape_once(matched_label)
    else
      escape_once(page.breadcrumb)
    end
  end

end