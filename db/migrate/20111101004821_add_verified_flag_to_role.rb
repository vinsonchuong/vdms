class AddVerifiedFlagToRole < ActiveRecord::Migration
  def self.up
    add_column :roles, :verified, :boolean, :default => false
  end

  def self.down
    remove_column :roles, :verified
  end
end
