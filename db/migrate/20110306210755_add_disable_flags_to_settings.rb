class AddDisableFlagsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :disable_faculty, :boolean, :default => false
    add_column :settings, :disable_peer_advisors, :boolean, :default => false
  end

  def self.down
    remove_column :settings, :disable_faculty
    remove_column :settings, :disable_peer_advisors
  end
end
