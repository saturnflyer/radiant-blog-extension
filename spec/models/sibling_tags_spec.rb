require File.dirname(__FILE__) + '/../spec_helper'

describe "Sibling Tags" do
  scenario :sibling_pages
  
  describe "called from an only child" do
    
    it "should not render unless_next/previous contents" do
      page(:solo)
      page.should render('<r:siblings><r:if_next>invisible</r:if_next></r:siblings>').as('')
      page.should render('<r:siblings><r:if_previous>invisible</r:if_previous></r:siblings>').as('')
    end
    
    it "should render unless_next/previous contents" do
      page(:solo)
      page.should render('<r:siblings><r:unless_next>visible</r:unless_next></r:siblings>').as('visible')
      page.should render('<r:siblings><r:unless_previous>visible</r:unless_previous></r:siblings>').as('visible')
    end
    
    it "should render nothing for <r:next/> tag" do
      page(:solo)
      page.should render('<r:siblings:next><r:title/></r:siblings:next>').as('')
    end
    
    it "should render nothing for <r:previous/> tag" do
      page(:solo)
      page.should render('<r:siblings:previous><r:title/></r:siblings:previous>').as('')
    end
    
  end
  
  describe "called from a child with a sibling" do
    
    it "should use next page with default sort options" do
      page(:kate)
      page.should render('<r:siblings:next><r:title/></r:siblings:next>').as('Amy')
    end
    it "should use previous page with default sort options" do
      page(:amy)
      page.should render('<r:siblings:previous><r:title/></r:siblings:previous>').as('Kate')
    end
    
    it "should use next page when sort order='desc'" do
      page(:amy)
      page.should render('<r:siblings:next order="desc"><r:title/></r:siblings:next>').as('Kate')
    end
    it "should use previous page when sort order='desc'" do
      page(:kate)
      page.should render('<r:siblings:previous order="desc"><r:title/></r:siblings:previous>').as('Amy')
    end
    
    it "should use next page when sort by='title'" do
      page(:amy)
      page.should render('<r:siblings:next by="title"><r:title/></r:siblings:next>').as('Kate')
    end
    it "should use previous page when sort by='title'" do
      page(:kate)
      page.should render('<r:siblings:previous by="title"><r:title/></r:siblings:previous>').as('Amy')
    end
    
    it "should use next page when sort by='title' and order='desc'" do
      page(:kate)
      page.should render('<r:siblings:next by="title" order="desc"><r:title/></r:siblings:next>').as('Amy')
    end
    it "should use previous page when sort by='title' and order='desc'" do
      page(:amy)
      page.should render('<r:siblings:previous by="title" order="desc"><r:title/></r:siblings:previous>').as('Kate')
    end
  end
  
  describe "called from a child with many siblings" do
    it "should skip unpublished pages when looking for next" do
      page(:happy).should render('<r:siblings:next by="title"><r:title/></r:siblings:next>').as('Sneezy')
      page(:sneezy).should render('<r:siblings:next><r:title/></r:siblings:next>').as('Happy')
    end
    
    it "should skip unpublished pages when looking for previous" do
      page(:sneezy).should render('<r:siblings:previous by="title"><r:title/></r:siblings:previous>').as('Happy')
      
      
      page(:happy).should render('<r:siblings:previous><r:title/></r:siblings:previous>').as('Sneezy')
    end
    
  end
  
  describe "called from scope other than the current page" do
  
    it "should operate within the specified scope" do
      # page(:home).should render('<r:find url="/mother-of-two"><r:children:first><r:title/></r:children:first></r:find>').as('Kate')
      
      page(:home).should render('<r:find url="/mother-of-two"><r:children:first><r:siblings:next><r:title/></r:siblings:next></r:children:first></r:find>').as('Amy')
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

  def page_children_each_tags(attr = nil)
    attr = ' ' + attr unless attr.nil?
    "<r:children:each#{attr}><r:slug /> </r:children:each>"
  end

  def page_children_first_tags(attr = nil)
    attr = ' ' + attr unless attr.nil?
    "<r:children:first#{attr}><r:slug /></r:children:first>"
  end

  def page_children_last_tags(attr = nil)
    attr = ' ' + attr unless attr.nil?
    "<r:children:last#{attr}><r:slug /></r:children:last>"
  end

  def page_eachable_children(page)
    page.children.select(&:published?).reject(&:virtual)
  end
  
end