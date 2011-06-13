class AddDivisionToTimeSlot < ActiveRecord::Migration
  def self.up
    add_column :time_slots, :division_id, :integer
  end

  def self.down
    drop_column :time_slots, :division_id
  end
end
