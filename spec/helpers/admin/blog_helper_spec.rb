require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::BlogHelper do
  dataset :users, :pages
  before do
    login_as :admin
    @admin = users(:admin)
    @admin.stub!(:blog_location).and_return('/')
    helper.stub!(:current_user).and_return(@admin)
  end
  describe "valid_user_blog_location?(location)" do
    it "should return false when the given location is blank" do
      helper.valid_user_blog_location?('').should be_false
    end
    it "should return true when a Page is found with the given location for it's URL" do
      helper.stub!(:user_blog_page).and_return(pages(:home))
      helper.valid_user_blog_location?('/').should be_true
    end
    it "should return false when a Page is not found with the given location for it's URL" do
      helper.stub!(:user_blog_page).and_return(nil)
      helper.valid_user_blog_location?('/').should be_false
    end
  end
  describe "new_blog_post_url" do
    it "should return the url for a new child page under the Radiant::Config 'blog.location.default' when it is a valid location" do
      @config.stub!(:[]).with('blog.location.default').and_return(pages(:home).url)
      @admin.stub!(:blog_location).and_return('')
      helper.new_blog_post_url.should == "http://test.host/admin/pages/#{pages(:home).id}/children/new"
    end
    it "should return the url for a new child page under the current user's blog_location when it is a valid location" do
      @config.stub!(:[]).with('blog.location.default').and_return(pages(:home).url)
      @admin.stub!(:blog_location).and_return(pages(:parent).url)
      helper.new_blog_post_url.should == "http://test.host/admin/pages/#{pages(:parent).id}/children/new"
    end
    it "should return an empty string when given an invalid URL" do
      @config.stub!(:[]).with('blog.location.default').and_return('')
      @admin.stub!(:blog_location).and_return('')
      helper.new_blog_post_url.should == ''
    end
  end
  describe "user_blog_page" do
    it "should find the page set in current user's blog_location" do
      helper.user_blog_page().should == pages(:home)
    end
    it "should find the page with the given URL" do
      Page.should_receive(:find_by_url).with('/').and_return(pages(:home))
      helper.user_blog_page('/').should == pages(:home)
    end
  end
end