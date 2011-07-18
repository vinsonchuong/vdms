class RefactorRankings < ActiveRecord::Migration
  def self.up
    drop_table :rankings
    create_table :rankings do |t|
      t.integer :rank
      t.string :type
      t.integer :ranker_id
      t.integer :rankable_id

      # Host Ranking
      t.boolean :mandatory, :default => false
      t.boolean :one_on_one, :default => false
      t.integer :num_time_slots, :default => 1
    end
  end

  def self.down
    drop_table :rankings
    create_table :rankings do |t|
      t.integer :rank
      t.string :type
      t.integer :faculty_id
      t.integer :admit_id
      t.boolean :mandatory
      t.integer :time_slots
      t.boolean :one_on_one
    end
  end
end
