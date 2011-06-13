class AddHostAndVisitorIdsToTimeSlot < ActiveRecord::Migration
  def self.up
    add_column :time_slots, :host_id, :integer
    add_column :time_slots, :visitor_id, :integer
  end

  def self.down
    remove_column :time_slots, :host_id
    remove_column :time_slots, :visitor_id
  end
end
