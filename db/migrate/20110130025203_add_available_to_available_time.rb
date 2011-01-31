class AddAvailableToAvailableTime < ActiveRecord::Migration
  def self.up
    add_column :available_times, :available, :boolean
  end

  def self.down
    remove_column :available_times, :available
  end
end
