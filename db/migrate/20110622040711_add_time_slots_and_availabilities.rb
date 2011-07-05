class AddTimeSlotsAndAvailabilities < ActiveRecord::Migration
  def self.up
    remove_columns :time_slots, :begin, :end
    rename_table :time_slots, :availabilities
    add_column :availabilities, :time_slot_id, :integer

    create_table :time_slots do |t|
      t.datetime :begin
      t.datetime :end
      t.integer :settings_id
    end
  end

  def self.down
    drop_table :time_slots

    remove_column :availabilities, :time_slot_id
    rename_table :availabilities, :time_slots
    add_column :time_slots, :begin, :datetime
    add_column :time_slots, :end, :datetime
  end
end
