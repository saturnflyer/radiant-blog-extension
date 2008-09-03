module AuthorTags
  include Radiant::Taggable
  class TagError < StandardError; end
  
    desc %{
    Renders the name of the author of the current page when used as a 
    single tag, but will set the scope to the current author when used
    as a double tag.
    
    *Usage:*
    <pre><code><r:author /></code></pre>
    <pre><code><r:author>text</r:author></code></pre>
  }
  tag 'author' do |tag|
    if tag.locals.author
      tag.double? ? tag.expand : tag.locals.author.name
    else
      page = tag.locals.page
      if tag.locals.author = page.created_by
        tag.double? ? tag.expand : tag.locals.author.name
      end
    end
  end
  
  [:name, :email].each do |att|
    desc %{
      Renders the #{att} of the current author
    }
    tag "author:#{att}" do |tag|
      tag.locals.author.send(att)
    end
  end
  
  desc %{
    Sets the scope for all Authors
    
    *Usage:*
    <pre><code><r:authors>...</r:authors></code></pre>
  }
  tag 'authors' do |tag|
    tag.expand
  end
  
  desc %{
    Renders its contents for each User in the collection. You may use
    the @limit@ and @offset@ attributes to alter the collection of authors.
    You may select authors by adding one or more to the @login@ attribute 
    and separating them by a comma
    
    *Usage:*
    <pre><code><r:authors:each [limit="10" offset="20" login="sean, john"]>...</r:authors:each></code></pre>
  }
  tag 'authors:each' do |tag|
    attr = tag.attr.symbolize_keys
    options = standard_options(attr)
    if attr[:login]
      login = attr[:login].gsub(' ','')
      logins = login.split(',')
      options[:conditions] = ['login in (?)', logins]
    end
    authors = User.find(:all, options)
    result = []
    tag.locals.authors = authors
    authors.each do |author|
      tag.locals.author = author
      result << tag.expand
    end
    result
  end
  
  [:name, :email].each do |method|
    desc %{
      Renders the #{method} of the current author
    }
    tag "authors:each:#{method}" do |tag|
      tag.locals.author.send(method)
    end
  end
  
  desc %{
    Sets the scope for the current author's pages.
  }
  tag "pages" do |tag|
    tag.locals.author = tag.locals.page.created_by unless tag.locals.author
    if tag.locals.author
      tag.locals.pages = tag.locals.author.pages
      tag.expand
    end
  end
  
  desc %{
    Renders the total number of pages by the current author.
  }
  tag "pages:count" do |tag|
    options = children_find_options(tag)
    tag.locals.pages.find(:all, options).size
  end
  
  desc %{
    Renders the contents for each page of the current author.
  }
  tag "pages:each" do |tag|
    attr = tag.attr.symbolize_keys
    options = children_find_options(tag)
    result = []
    url = attr[:url]
    if url
      found = Page.find_by_url(absolute_path_for(tag.locals.page.url, url))
      if page_found?(found)
        found.children.find(:all, options).each do |p|
          tag.locals.page = p
          result << tag.expand
        end
      end
    else
      tag.locals.pages.find(:all, options).each do |p|
        tag.locals.page = p
        result << tag.expand
      end
    end
    result
  end
  
    private

    def children_find_options(tag)
      attr = tag.attr.symbolize_keys

      options = standard_options(attr)

      by = (attr[:by] || 'published_at').strip
      order = (attr[:order] || 'asc').strip
      order_string = ''
      if self.attributes.keys.include?(by)
        order_string << by
      else
        raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
      end
      if order =~ /^(asc|desc)$/i
        order_string << " #{$1.upcase}"
      else
        raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
      end
      options[:order] = order_string

      status = (attr[:status] || 'published').downcase
      unless status == 'all'
        stat = Status[status]
        unless stat.nil?
          options[:conditions] = ["(virtual = ?) and (status_id = ?)", false, stat.id]
        else
          raise TagError.new(%{`status' attribute of `each' tag must be set to a valid status})
        end
      else
        options[:conditions] = ["virtual = ?", false]
      end
      options
    end
    
    def standard_options(attr)
      options = {}
      [:limit, :offset].each do |symbol|
        if number = attr[symbol]
          if number =~ /^\d{1,4}$/
            options[symbol] = number.to_i
          else
            raise TagError.new("`#{symbol}' attribute of `each' tag must be a positive number between 1 and 4 digits")
          end
        end
      end
      options
    end
end