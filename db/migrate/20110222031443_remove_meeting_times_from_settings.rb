class RemoveMeetingTimesFromSettings < ActiveRecord::Migration
  def self.up
    remove_column :settings, :meeting_times
  end

  def self.down
    add_column :settings, :meeting_times, :string
  end
end
