module Admin::BlogHelper
  def new_blog_post_url
    result = ''
    if valid_user_blog_location?(current_user.blog_location)
        result = new_admin_page_child_url(user_blog_page)
    elsif valid_user_blog_location?(@config['blog.location.default'])
        result = new_admin_page_child_url(user_blog_page(@config['blog.location.default']))
    end
    result
  end
  
  def valid_user_blog_location?(location)
    !location.blank? && !user_blog_page(location).blank?
  end
  
  def user_blog_page(location = current_user.blog_location)
    Page.find_by_url(location)
  end
end