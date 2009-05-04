class SiblingPagesDataset < Dataset::Base
  uses :home_page
  
  def load
    create_page "Single mum" do
      create_page "Solo",  :published_at => DateTime.parse('2003-08-01 08:12:01')
    end
    
    create_page "Mother of two" do
      create_page "Amy",   :published_at => DateTime.parse('2003-01-01 08:12:01')
      create_page "Kate",  :published_at => DateTime.parse('2002-10-01 04:02:10')
    end
    
    create_page "Mother of dwarves" do
      create_page "Bashful", :published_at => DateTime.parse('2005-10-07 12:12:12')
      create_page "Doc",     :published_at => DateTime.parse('2004-09-08 12:12:12')
      create_page "Dopey",   :published_at => DateTime.parse('2003-08-09 12:12:12')
      create_page "Grumpy",  :published_at => DateTime.parse('2002-07-10 12:12:12')
      create_page "Happy",   :published_at => DateTime.parse('2001-06-11 12:12:12')
      create_page "Sleepy",  :status_id => Status[:draft].id
      create_page "Sneezy",  :published_at => DateTime.parse('2000-05-12 12:12:12')
    end
  end
  
end


