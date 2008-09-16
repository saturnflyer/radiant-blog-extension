# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class BlogExtension < Radiant::Extension
  version "1.0"
  description "Provides features for blogging."
  url "http://saturnflyer.com/"
  
  # define_routes do |map|
  #   map.connect 'admin/author/:action', :controller => 'admin/author'
  # end
  
  def activate
    Page.send :include, AuthorTags
    Page.send :include, SiblingTags
    User.class_eval {
      has_many :pages, :foreign_key => :created_by_id unless self.respond_to?(:pages)
    }
    
    admin.user.edit.add :form, 'bio', :after => 'edit_notes'
  end
  
  def deactivate
    # admin.tabs.remove "Author"
  end
  
end