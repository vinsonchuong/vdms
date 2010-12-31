class CreateAdmitsMeetings < ActiveRecord::Migration
  def self.up
    create_table :admits_meetings, :id => false do |t|
      t.integer :admit_id, :null => false
      t.integer :meeting_id, :null => false
    end
    add_index :admits_meetings, [:admit_id, :meeting_id], :unique => true
  end

  def self.down
    remove_index :admits_meetings, :column => [:admit_id, :meeting_id]
    drop_table :admits_meetings
  end
end
