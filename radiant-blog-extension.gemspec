# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-blog-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-blog-extension"
  s.version     = RadiantBlogExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantBlogExtension::AUTHORS
  s.email       = RadiantBlogExtension::EMAIL
  s.homepage    = RadiantBlogExtension::URL
  s.summary     = RadiantBlogExtension::SUMMARY
  s.description = RadiantBlogExtension::DESCRIPTION

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]

  s.post_install_message = %{
  Add this to your radiant project with:

    config.gem 'radiant-blog-extension', :version => '~> #{RadiantBlogExtension::VERSION}'

  }
end
