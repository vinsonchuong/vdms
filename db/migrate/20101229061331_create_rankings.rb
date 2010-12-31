class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.integer :rank
      t.string :type

      # AdmitRanking
      t.integer :faculty_id
      t.integer :admit_id
      t.boolean :mandatory
      t.integer :time_slots
      t.boolean :one_on_one

      # FacultyRanking
      # t.integer :admit_id
      # t.integer :faculty_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rankings
  end
end
