Radiant.config do |config|
  config.namespace('blog.location') do |blog|
    blog.define 'configurable?', :default => false
    blog.define 'default', :allow_blank => true, :validate_with => lambda { |setting| 
      page = Page.find_by_path(setting.value)
      setting.errors.add :value, :not_a_page if page.nil? || page.is_a?(FileNotFoundPage)
    }
  end
end