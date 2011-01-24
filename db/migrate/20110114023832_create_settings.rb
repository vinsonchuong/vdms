class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :meeting_times
      t.integer :unsatisfied_admit_threshold

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
