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
    if Page.table_exists? #allow bootstrapping
      Page.send :include, AuthorTags
      Page.send :include, SiblingTags
      User.class_eval {
        has_many :pages, :foreign_key => :created_by_id unless self.respond_to?(:pages)
      }
      Radiant::Config['blog.location.configurable?'] = false unless Radiant::Config['blog.location.configurable?'] == true
      Radiant::Config['blog.location.default'] = '' unless not Radiant::Config['blog.location.default'].blank?
      admin.user.edit.add :form, 'blog_details', :after => 'edit_notes'
      if admin.respond_to?(:dashboard)
        admin.dashboard.index.add :current_user_draft_pages_bottom, 'new_page_link'
        Admin::DashboardController.class_eval{
          helper Admin::BlogHelper
        }
      end
    end
  end
  
  def deactivate
    # admin.tabs.remove "Author"
  end
  
end