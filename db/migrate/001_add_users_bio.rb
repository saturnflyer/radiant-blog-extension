class AddUsersBio < ActiveRecord::Migration
  def self.up
    add_column :users, :bio, :text
    add_column :users, :bio_filter_id, :string, :limit => 25
  end
  def self.down
    remove_column :users, :bio_filter_id
    remove_column :users, :bio
  end
end