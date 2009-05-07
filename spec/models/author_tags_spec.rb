require File.dirname(__FILE__) + '/../spec_helper'

describe "AuthorTags" do
  dataset :users_and_pages
  
  describe "<r:author>" do
    it "should render the author of the current page" do
      page.should render('<r:author />').as('Admin')
    end

    it "should render nothing when the page has no author" do
      page(:no_user).should render('<r:author />').as('')
    end
    
    it "should render its contents when used as a double tag" do
      page.should render('<r:author>true</r:author>').as('true')
    end
    
    it "should set the author to that with the given login" do
      page.should render('<r:author login="admin" />').as('Admin')
    end
  end
  
  describe "<r:author:name>" do
    it "should render the name of the current author" do
      page.should render('<r:author:name />').as('Admin')
    end
  end
  
  describe "<r:author:email>" do
    it "should render the email of the current author" do
      page.should render('<r:author:email />').as('admin@example.com')
    end
    it "should render nothing if the current author has no email" do
      page.created_by.update_attribute('email',nil)
      page.should render('<r:author:email />').as('')
    end
  end
  
  describe "<r:author:bio>" do
    it "should render the bio of the current author" do
      page.created_by.update_attribute('bio',"This is all about me.")
      page.should render('<r:author:bio />').as('This is all about me.')
    end
    it "should render nothing if the current author has no bio" do
      page.created_by.update_attribute('bio',nil)
      page.should render('<r:author:bio />').as('')
    end
    it "should filter the bio content with the bio_filter" do
      page.created_by.update_attribute('bio',"This is *all* about me.")
      page.created_by.update_attribute('bio_filter_id','Textile')
      page.should render('<r:author:bio />').as('<p>This is <strong>all</strong> about me.</p>')
    end
  end
  
  describe "<r:author:gravatar_url />" do
    before :each do
      page.created_by.stub!(:email).and_return("seancribbs@gmail.com")
      @base_url = "http://www.gravatar.com/avatar/8802b1fa1b53e2197beea9454244f847"
    end

    it "should render the base url" do
      page.should render('<r:author:gravatar_url />').as(@base_url)
    end
    
    it "should render the url with a size" do
      page.should render('<r:author:gravatar_url size="30" />').as("#{@base_url}?s=30")
    end
    
    it "should render the url with a rating" do
      page.should render('<r:author:gravatar_url rating="G" />').as("#{@base_url}?r=g")
    end
    
    it "should render the url with a default" do
      page.should render('<r:author:gravatar_url default="identicon" />').as("#{@base_url}?d=identicon")
    end
    
    it "should render the url with a format" do
      page.should render('<r:author:gravatar_url format="jpg" />').as("#{@base_url}.jpg")
    end
    
    it "should render the url with all options" do
      page.should render('<r:author:gravatar_url size="30" rating="G" default="identicon" format="jpg"/>').as("#{@base_url}.jpg?s=30&d=identicon&r=g")
    end
  end
  
  describe "<r:authors>" do
    it "should render it's contents" do
      page.should render('<r:authors>Authors</r:authors>').as('Authors')
    end
  end
  
  describe "<r:authors:each>" do
    it "should render it's contents for each author" do
      page.should render('<r:authors:each>author </r:authors:each>').as('author author author author author ')
    end
    
    it "should allow a login attribute to limit the group of authors to the given login" do
      page.should render('<r:authors:each login="admin">author </r:authors:each>').as('author ')
    end
    
    it "should return no authors when given a non-existant login for the login attribute" do
      page.should render('<r:authors:each login="none">author </r:authors:each>').as('')
    end
    
    it "should allow a comma delimited list of logins to limit the group of authors" do
      page.should render('<r:authors:each login="admin, another">author </r:authors:each>').as('author author ')
    end
    
    it "should allow a limit attribute to limit the collection" do
      page.should render('<r:authors:each limit="3">author </r:authors:each>').as('author author author ')
    end
    
    it "should allow a offset attribute to offset the collection" do
      page.should render('<r:authors:each limit="2" offset="3">author </r:authors:each>').as('author author ')
    end

    it 'should error with a "limit" attribute that is not a positive number between 1 and 4 digits' do
      message = "`limit' attribute of `each' tag must be a positive number between 1 and 4 digits"
      page.should render('<r:authors:each limit="-10"></r:authors:each>').with_error(message)
    end

    it 'should error with a "offset" attribute that is not a positive number between 1 and 4 digits' do
      message = "`offset' attribute of `each' tag must be a positive number between 1 and 4 digits"
      page.should render('<r:authors:each offset="a"></r:authors:each>').with_error(message)
    end
  end
  
  describe "<r:authors:each:name>" do
    it "should render the name of the current author" do
      page.should render("<r:authors:each><r:name /> </r:authors:each>").as('Admin Another Developer Existing Non-admin ')
    end
  end
  
  describe "<r:authors:each:email>" do
    it "should render the email of the current author" do
      page.should render("<r:authors:each><r:email /> </r:authors:each>").as('admin@example.com another@example.com developer@example.com existing@example.com non_admin@example.com ')
    end
    
    it "should render nothing if the current author has no email" do
      users(:admin).update_attribute(:email, nil)
      page.should render('<r:authors:each login="admin"><r:email /></r:authors:each>').as('')
    end
  end
  
  describe "<r:authors:each:bio>" do
    it "should render the bio of the current author" do
      User.find(:all).each {|user| user.update_attribute('bio', "My bio.")}
      page.should render("<r:authors:each><r:bio /> </r:authors:each>").as('My bio. My bio. My bio. My bio. My bio. ')
    end
    
    it "should render nothing if the current author has no bio" do
      users(:admin).update_attribute(:bio, nil)
      page.should render('<r:authors:each login="admin"><r:bio /></r:authors:each>').as('')
    end
  end
  
  describe "<r:pages>" do
    it "should render the contents if there is a current author" do
      page.created_by = users(:admin)
      page.should render('<r:pages>true</r:pages>').as('true')
    end
    it "should not render the contents if there is no current author" do
      page.created_by = nil
      page.should render('<r:pages>true</r:pages>').as('')
    end
  end
  
  describe "<r:pages:each>" do
    it "should render it's contents sorting the author's pages by the given by attribute" do
      page.should render('<r:pages:each limit="5" by="slug"><r:slug /> </r:pages:each>').as('/ a another article article-2 ')
    end
    
    it "should render it's contents for each of the author's visible pages" do
      page_marks = 'x' * page.created_by.pages.find(:all, :conditions => {:status_id => 100, :virtual => false}).size
      page.should render('<r:pages:each>x</r:pages:each>').as(page_marks)
    end
    
    it "should render it's contents limiting the author's pages to the given limit attribute" do
      page.should render('<r:pages:each limit="3"><r:title /> </r:pages:each>').as('Article Article 2 Article 3 ')
    end
    
    it "should offset the pages when given limit and offset attributes between 1 and 4 digits" do
      page.should render('<r:pages:each limit="3" offset="1"><r:title /> </r:pages:each>').as('Article 2 Article 3 Article 4 ')
    end

    it 'should error with a "limit" attribute that is not a positive number between 1 and 4 digits' do
      message = "`limit' attribute of `each' tag must be a positive number between 1 and 4 digits"
      page.should render('<r:pages:each limit="-10"></r:pages:each>').with_error(message)
    end

    it 'should error with a "offset" attribute that is not a positive number between 1 and 4 digits' do
      message = "`offset' attribute of `each' tag must be a positive number between 1 and 4 digits"
      page.should render('<r:pages:each offset="a"></r:pages:each>').with_error(message)
    end
    
    it "should find the author's pages as children of the page url in the given url attribute" do
      page.should render('<r:pages:each url="/parent"><r:title /> </r:pages:each>').as('Child Child 2 Child 3 ')
    end
  end

  describe "<r:pages:count>" do
    it "should render the number of visible pages for the current author" do
      page.should render('<r:authors:each login="admin"><r:pages:count /></r:authors:each>').as('31')
    end
  end
  
  private
    def page(symbol = nil)
      if symbol.nil?
        @page ||= pages(:assorted)
      else
        @page = pages(symbol)
      end
    end
end