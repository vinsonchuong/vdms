class AddDisableSchedulertoEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :disable_scheduler, :boolean, :default => false
  end

  def self.down
    drop_column :events, :disable_scheduler
  end
end
