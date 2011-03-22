class AddDisableSchedulerFlagToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :disable_scheduler, :boolean, :default => false
  end

  def self.down
    remove_column :settings, :disable_scheduler
  end
end
