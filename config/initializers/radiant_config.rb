Radiant.config do |config|
  config.namespace 'blog' do
    blog.define 'location.configurable?', :default => false
    blog.define 'location.default', :default => ""
  end
end 
