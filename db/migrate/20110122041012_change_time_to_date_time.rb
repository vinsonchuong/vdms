class ChangeTimeToDateTime < ActiveRecord::Migration
  def self.up
    change_column :available_times, :begin, :datetime
    change_column :available_times, :end, :datetime
    change_column :meetings, :time, :datetime
  end

  def self.down
  end
end
