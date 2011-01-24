class ChangeAvailableTimeToPolymorphic < ActiveRecord::Migration
  def self.up
    remove_column :available_times, :person_id
    add_column :available_times, :schedulable_id, :integer
    add_column :available_times, :schedulable_type, :string
  end

  def self.down
    add_column :available_times, :person_id, :integer
    remove_column :available_times, :schedulable_id
    remove_column :available_times, :schedulable_type
  end
end
