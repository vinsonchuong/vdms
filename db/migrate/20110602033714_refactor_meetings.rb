class RefactorMeetings < ActiveRecord::Migration
  def self.up
    drop_table :meetings
    create_table :meetings do |t|
      t.integer :host_time_slot_id
      t.integer :visitor_time_slot_id
    end
  end

  def self.down
    drop_table :meetings
    create_table :meetings do |t|
      t.time :time
      t.string :room
      t.integer :faculty_id

      t.timestamps
    end
  end
end
