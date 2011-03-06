class ChangeMeetingTimeToDatetimeField < ActiveRecord::Migration
  def self.up
    remove_column :meetings, :time
    add_column :meetings, :time, :datetime
  end

  def self.down
    remove_column :meetings, :time
    add_column :meetings, :time, :time
  end
end
