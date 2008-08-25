require File.dirname(__FILE__) + '/../spec_helper'

describe "Sibling Tags" do
  scenario :sibling_pages
  
  describe "with only child" do
    it "should not have any siblings" do
      page(:solo)
      page.should render('<r:siblings><r:if_next>invisible</r:if_next></r:siblings>').as('')
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