class ChangeMeetingTimeToDatetimeField < ActiveRecord::Migration
  def self.up
    change_column :meetings, :time, :datetime
  end

  def self.down
    change_column :meetings, :datetime, :time
  end
end
