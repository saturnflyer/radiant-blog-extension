module SiblingTags
  include Radiant::Taggable
  
  desc %{
    Gives access to a page's siblings.
  }
  tag 'siblings' do |tag|
    tag.locals.siblings = tag.locals.page.parent.children
    tag.expand
  end
  
  desc %{
    Only render the contents of this tag if the current page has a sibling *after* it, when sorted according to the @order@ and @by@ options. 
    
    See @<siblings:next/>@ for a more detailed description of the sorting options.
  }
  tag 'siblings:if_next' do |tag|
    if next_sibling = find_next_sibling(tag)
      tag.expand
    end
  end
  
  desc %{
    Only render the contents of this tag if the current page has a sibling *before* it, when sorted according to the @order@ and @by@ options. 
    
    See @<siblings:next/>@ for a more detailed description of the sorting options.
  }
  tag 'siblings:if_previous' do |tag|
    if previous_sibling = find_previous_sibling(tag)
      tag.expand
    end
  end
  
  desc %{
    Only render the contents of this tag if the current page is the last of its siblings, when sorted according to the @order@ and @by@ options. 
    
    See @<siblings:next/>@ for a more detailed description of the sorting options.
  }
  tag 'siblings:unless_next' do |tag|
    unless next_sibling = find_next_sibling(tag)
      tag.expand
    end
  end

  desc %{
    Only render the contents of this tag if the current page is the first of its siblings, when sorted according to the @order@ and @by@ options. 
    
    See @<siblings:next/>@ for a more detailed description of the sorting options.
  }
  tag 'siblings:unless_previous' do |tag|
    unless previous_sibling = find_previous_sibling(tag)
      tag.expand
    end
  end

  desc %{
    All Radiant tags within a @<r:siblings:next/>@ block are interpreted in the context
    of the next sibling page. 
    
    The order in which siblings are sorted can be manipulated using all the same attributes
    as the @<r:children:each/>@ tag. If no attributes are supplied, the siblings will
    have order = "published_at ASC". The @by@ attribute allows you to order by any page 
    properties stored in the database, the most likely of these to be useful are @published_at@
    and @title@.
    
    *Usage:*
    <pre><code><r:siblings:next [by="published_at|title"] [order="asc|desc"] [status="published|all"]/>...</r:siblings:next></code></pre>
  }
  tag 'siblings:next' do |tag|
    if next_sibling = find_next_sibling(tag)
      tag.locals.page = next_sibling
      tag.expand
    end
  end
  
  desc %{
    All Radiant tags within a @<r:siblings:previous/>@ block are interpreted in the context
    of the previous sibling page, when sorted according to the @order@ and @by@ options.
    
    See @<siblings:next/>@ for a more detailed description of the sorting options.
    
    *Usage:*
    <pre><code><r:siblings:previous [by="published_at|title"] [order="asc|desc"] 
    [status="published|all"]/>...</r:siblings:previous></code></pre>
  }
  tag 'siblings:previous' do |tag|
    if previous_sibling = find_previous_sibling(tag)
      tag.locals.page = previous_sibling
      tag.expand
    end
  end
  
  private
  
  def find_next_sibling(tag)
    tag.locals.siblings.find(:first, siblings_find_options(tag,"next"))
  end
  
  def find_previous_sibling(tag)
    sorted = tag.locals.siblings.find(:all, siblings_find_options(tag,"previous"))
    sorted.last unless sorted.empty?
  end
  
  def siblings_find_options(tag,direction="next")
    # from Radiant core, children_find_options returns something like:
    # { :conditions => ["(virtual = ?) and (status_id = ?)", false, 100], 
    #   :order=>"published_at ASC" }
    options = children_find_options(tag)
    attr = tag.attr.symbolize_keys

    by = (attr[:by] || 'published_at').strip
    order = (attr[:order] || 'asc').strip
    
    if order.downcase == "asc"
      if direction == "previous"
        next_condition =  " and (#{by} < ?)"
      else
        next_condition = " and (#{by} > ?)"
      end
    else
      if direction == "previous"
        next_condition = " and (#{by} > ?)"
      else
        next_condition = " and (#{by} < ?)"
      end
    end
    
    options[:conditions].first << next_condition
    options[:conditions] << tag.locals.page.send(by)
    options
  end
  
end