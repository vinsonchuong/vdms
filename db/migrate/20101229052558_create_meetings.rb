class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.time :time
      t.string :room
      t.integer :faculty_id
      t.integer :max_admits_per_meeting

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
