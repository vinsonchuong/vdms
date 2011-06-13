class RefactorAvailableTime < ActiveRecord::Migration
  def self.up
    remove_column :available_times, :schedulable_id
    remove_column :available_times, :schedulable_type
    rename_table :available_times, :time_slots
    add_column :time_slots, :type, :string
  end

  def self.down
    remove_column :time_slots, :type
    rename_table :time_slots, :available_times
    add_column :available_times, :schedulable_id, :integer
    add_column :available_times, :schedulable_type, :string
  end
end
