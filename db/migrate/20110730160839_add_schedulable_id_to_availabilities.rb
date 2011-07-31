class AddSchedulableIdToAvailabilities < ActiveRecord::Migration
  def self.up
    remove_column :availabilities, :host_id
    remove_column :availabilities, :visitor_id
    add_column :availabilities, :schedulable_id, :integer
  end

  def self.down
    add_column :availabilities, :host_id, :integer
    add_column :availabilities, :visitor_id, :integer
    remove_column :availabilities, :schedulable_id
  end
end
