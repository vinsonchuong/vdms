class AddMaxMeetingsPerAdmitToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :max_meetings_per_admit, :integer, :default => 5
  end

  def self.down
    remove_column :settings, :max_meetings_per_admit
  end
end
