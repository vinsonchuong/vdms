class RemoveAvailableTimesAndScheduleAttributes < ActiveRecord::Migration
  def self.up
    remove_column :people, :schedule
    remove_column :people, :available_times
  end

  def self.down
    add_column :people, :schedule, :string
    add_column :people, :available_times, :string
  end
end
