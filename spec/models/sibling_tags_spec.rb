require File.dirname(__FILE__) + '/../spec_helper'

describe "Sibling Tags" do
  scenario :sibling_pages
  
  describe "called from the home page" do
    it "should output nothing" do
      page(:home).should render('<r:siblings:next><r:title/></r:siblings:next>').as('')
    end
    it "should not have any siblings" do
      page(:home).should render('<r:if_siblings>NO!</r:if_siblings>').as('')
      page(:home).should render('<r:unless_siblings>YES</r:unless_siblings>').as('YES')
    end
  end
  
  describe "called from an only child" do
    
    it "should not have any siblings" do
      page(:solo).should render('<r:if_siblings>NO!</r:if_siblings>').as('')
      page(:solo).should render('<r:unless_siblings>YES</r:unless_siblings>').as('YES')
    end
    
    it "should render contents of <r:siblings/> when there are none" do
      page(:solo)
      page.should render('<r:siblings>visible</r:siblings>').as('visible')
    end
    
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
    
    it "should have a sibling" do
      page(:kate).should render('<r:if_siblings>YES</r:if_siblings>').as('YES')
      page(:kate).should render('<r:unless_siblings>NO!</r:unless_siblings>').as('')
    end
    
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
      page(:home)
      page.should render('<r:find url="/mother-of-two"><r:children:first><r:siblings:next><r:title/></r:siblings:next></r:children:first></r:find>').as('Amy')
      page.should render('<r:find url="/mother-of-two"><r:children:last><r:siblings:previous><r:title/></r:siblings:previous></r:children:last></r:find>').as('Kate')
      page.should render('<r:find url="/mother-of-two"><r:children:last><r:siblings:next><r:title/></r:siblings:next></r:children:last></r:find>').as('')
      page.should render('<r:find url="/mother-of-two"><r:children:first><r:siblings:previous><r:title/></r:siblings:previous></r:children:first></r:find>').as('')
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