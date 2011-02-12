class CreateAvailableTimes < ActiveRecord::Migration
  def self.up
    create_table :available_times do |t|
      t.datetime :begin
      t.datetime :end
      t.string :room
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :available_times
  end
end
