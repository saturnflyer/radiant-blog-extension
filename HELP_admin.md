If you have [Dashboard](http://ext.radiantcms.org/extensions/40-dashboard) installed you'll have links to
create a new blog post there. This is a convenience link in the case that the Radiant link to add a child
page to your blog is buried somewhere in your page tree. This means that you can go to the Dashboard instead
of hunting through your page tree to add a new blog post.

You may set a default location for your blog posts with `Radiant::Config['blog.location.default'] = '/company/blog'`
(the appropriate location on your website).

You may also configure a blog location for each user with `Radiant::Config['blog.location.configurable?'] = 'true'`.
This will allow you to edit a user's details with a blog location such as "/blog/jim", "/blog/amy", "/blog/tech", 
"/writing/things", or whatever may be appropriate for your site.