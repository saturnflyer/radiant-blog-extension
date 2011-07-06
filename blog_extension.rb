# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'
require "radiant-blog-extension"

class BlogExtension < Radiant::Extension
  version RadiantTaggableExtension::VERSION
  description RadiantTaggableExtension::DESCRIPTION
  url RadiantTaggableExtension::URL
  
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
    end
  end
  
  def deactivate
  end
  
end