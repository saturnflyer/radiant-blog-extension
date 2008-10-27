module SiblingTags
  include Radiant::Taggable
  
  desc %{
    Set's the scope for a page's siblings. 
  }
  tag 'siblings' do |tag|
    tag.locals.filter_attributes = tag.attr || {}
    tag.expand
  end
    
    desc %{
      Loops through each sibling and outputs the contents
    }
    tag 'siblings:each' do |tag|
      result = []
      inherit_filter_attributes(tag)
      tag.locals.siblings = tag.locals.page.parent.children.find(:all, siblings_find_options(tag))
      tag.locals.siblings.each do |sib|
        tag.locals.page = sib
        result << tag.expand
      end
      result
    end
    
    desc %{
      Only renders the contents of this tag if the current page has any published siblings.
    }
    tag 'if_siblings' do |tag|
      if parent = tag.locals.page.parent
        if parent.children.find(:all, siblings_find_options(tag)).size > 0
          tag.expand
        end
      end
    end
    
    desc %{
      Only renders the contents of this tag if the current page has no published siblings.
    }
    tag 'unless_siblings' do |tag|
      if !tag.locals.page.parent or tag.locals.page.parent.children.find(:all, siblings_find_options(tag)).size == 0
        tag.expand
      end
    end
    
    desc %{
      Only render the contents of this tag if the current page has a sibling *after* it, when sorted according to the @order@ and @by@ options. 
      
      See @<siblings:next/>@ for a more detailed description of the sorting options.
    }
    tag 'siblings:if_next' do |tag|
      inherit_filter_attributes(tag)
      tag.expand if find_next_sibling(tag)
    end
    
    desc %{
      Only render the contents of this tag if the current page has a sibling *before* it, when sorted according to the @order@ and @by@ options. 
      
      See @<siblings:next/>@ for a more detailed description of the sorting options.
    }
    tag 'siblings:if_previous' do |tag|
      inherit_filter_attributes(tag)
      tag.expand if find_previous_sibling(tag)
    end
    
    desc %{
      Only render the contents of this tag if the current page is the last of its siblings, when sorted according to the @order@ and @by@ options. 
      
      See @<siblings:next/>@ for a more detailed description of the sorting options.
    }
    tag 'siblings:unless_next' do |tag|
      inherit_filter_attributes(tag)
      tag.expand unless find_next_sibling(tag)
    end
    
    desc %{
      Only render the contents of this tag if the current page is the first of its siblings, when sorted according to the @order@ and @by@ options. 
      
      See @<siblings:next/>@ for a more detailed description of the sorting options.
    }
    tag 'siblings:unless_previous' do |tag|
      inherit_filter_attributes(tag)
      tag.expand unless find_previous_sibling(tag)
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
      inherit_filter_attributes(tag)
      tag.expand if tag.locals.page = find_next_sibling(tag)
    end
    
    desc %{
      Displays its contents for each of the following pages according to the given
      attributes. See @<r:siblings:each>@ for details about the attributes.
    }
    tag 'siblings:each_before' do |tag|
      inherit_filter_attributes(tag)
      result = []
      tag.locals.siblings = find_siblings_before(tag)
      tag.locals.siblings.each do |sib|
        tag.locals.page = sib
        result << tag.expand
      end
      result
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
      inherit_filter_attributes(tag)
      tag.expand if tag.locals.page = find_previous_sibling(tag)
    end
    
    desc %{
      Displays its contents for each of the following pages according to the given
      attributes. See @<r:siblings:each>@ for details about the attributes.
    }
    tag 'siblings:each_after' do |tag|
      inherit_filter_attributes(tag)
      result = []
      tag.locals.siblings = find_siblings_after(tag)
      tag.locals.siblings.each do |sib|
        tag.locals.page = sib
        result << tag.expand
      end
      result
    end
    
    private
    
    def inherit_filter_attributes(tag)
      tag.attr ||= {}
      tag.attr.reverse_merge!(tag.locals.filter_attributes)
    end
    
    def find_next_sibling(tag)
      if tag.locals.page.parent
        tag.attr['adjacent'] = 'next'
        tag.locals.page.parent.children.find(:first, adjacent_siblings_find_options(tag))
      end
    end
    
    def find_siblings_before(tag)
      if tag.locals.page.parent
        tag.attr['adjacent'] = 'previous'
        tag.locals.page.parent.children.find(:all, adjacent_siblings_find_options(tag)).reverse!
      end
    end
    
    def find_previous_sibling(tag)
      if tag.locals.page.parent
        tag.attr['adjacent'] = 'previous'
        sorted = tag.locals.page.parent.children.find(:all, adjacent_siblings_find_options(tag))
        sorted.last unless sorted.blank?
      end
    end
    
    def find_siblings_after(tag)
      if tag.locals.page.parent
        tag.attr['adjacent'] = 'next'
        tag.locals.page.parent.children.find(:all, adjacent_siblings_find_options(tag))
      end
    end
    
    def adjacent_siblings_find_options(tag)
      options = siblings_find_options(tag)
      adjacent_condition = attr_or_error(tag, :attribute_name => 'adjacent', :default => 'next', :values => 'next, previous')
      attribute_sort = (tag.attr[:by] || tag.attr["by"] || 'published_at').strip
      attribute_order = attr_or_error(tag, :attribute_name => 'order', :default => 'asc', :values => 'desc, asc')
      
      find_less_than    = " and (#{attribute_sort} < ?)"
      find_greater_than = " and (#{attribute_sort} > ?)"
      
      if attribute_order == "asc"
        adjacent_find_condition = (adjacent_condition == 'previous' ? find_less_than : find_greater_than)
      else
        adjacent_find_condition = (adjacent_condition == 'previous' ? find_greater_than : find_less_than)
      end
      
      options[:conditions].first << adjacent_find_condition
      options[:conditions] << tag.locals.page.send(attribute_sort)
      
      options
    end
    
    def siblings_find_options(tag)
      options = children_find_options(tag)
      options[:conditions].first << ' and id != ?'
      options[:conditions] << tag.locals.page.id
      options
    end
end