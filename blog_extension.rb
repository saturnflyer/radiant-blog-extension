# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class BlogExtension < Radiant::Extension
  version "1.0"
  description "Provides features for blogging."
  url "http://saturnflyer.com/"
  
  def activate
    if Page.table_exists? #allow bootstrapping
      Page.send :include, AuthorTags
      Page.send :include, SiblingTags
      User.class_eval {
        has_many :pages, :foreign_key => :created_by_id unless self.respond_to?(:pages)
      }
      admin.user.edit.add :form, 'blog_details', :after => 'edit_notes'
      admin.configuration.show.add :config, 'admin/configuration/blog', :after => 'defaults'
      admin.configuration.edit.add :form,   'admin/configuration/edit_blog', :after => 'edit_defaults'

      if admin.respond_to?(:dashboard)
        Admin::DashboardController.send :helper, Admin::BlogHelper

        # some of these will not be in use, depending on which dashboard you've got, but it shouldn't matter.
        admin.dashboard.index.add :shortcuts, 'new_blog_entry'
        admin.dashboard.index.add :current_user_draft_pages_top, 'new_page_link'
        admin.dashboard.index.add :current_user_published_pages_top, 'new_page_link'
        admin.dashboard.index.add :user_action_list, 'new_post_link'
      end
    end
  end
  
  def deactivate
  end
  
end