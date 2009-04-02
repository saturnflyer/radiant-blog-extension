class AddUsersBlogLocation < ActiveRecord::Migration
  def self.up
    add_column :users, :blog_location, :string
  end
  def self.down
    remove_column :users, :blog_location
  end
end