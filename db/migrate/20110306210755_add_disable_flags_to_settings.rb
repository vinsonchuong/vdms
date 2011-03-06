class AddDisableFlagsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :disable_faculty, :boolean, :default => 0
    add_column :settings, :disable_peer_advisors, :boolean, :default => 0
  end

  def self.down
    remove_column :settings, :disable_faculty
    remove_column :settings, :disable_peer_advisors
  end
end
