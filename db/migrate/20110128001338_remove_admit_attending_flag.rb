class RemoveAdmitAttendingFlag < ActiveRecord::Migration
  def self.up
    remove_column :people, :attending
  end

  def self.down
    add_column :people, :attending, :boolean
  end
end
