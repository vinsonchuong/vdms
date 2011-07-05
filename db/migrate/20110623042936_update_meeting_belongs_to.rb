class UpdateMeetingBelongsTo < ActiveRecord::Migration
  def self.up
    rename_column :meetings, :host_time_slot_id, :host_availability_id
    rename_column :meetings, :visitor_time_slot_id, :visitor_availability_id
  end

  def self.down
    rename_column :meetings, :host_availability_id, :host_time_slot_id
    rename_column :meetings, :visitor_availability_id, :visitor_time_slot_id
  end
end
