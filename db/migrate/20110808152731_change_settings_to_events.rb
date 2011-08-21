class ChangeSettingsToEvents < ActiveRecord::Migration
  def self.up
    drop_table :settings
    create_table :events do |t|
      # Basic Info
      t.string :name
      t.integer :meeting_length
      t.integer :meeting_gap

      # Permissions
      t.boolean :disable_facilitators, :default => false
      t.boolean :disable_hosts, :default => false

      # Meeting Constraints
      t.integer :max_meetings_per_visitor
    end
    rename_column :time_slots, :settings_id, :event_id
  end

  def self.down
    drop_table :events
    create_table :settings do |t|
      t.string :meeting_times
      t.integer :unsatisfied_admit_threshold
      t.boolean :disable_faculty, :default => false
      t.boolean :disable_peer_advisiors, :default => false
      t.integer :admit_weight
      t.integer :faculty_weight
      t.integer :rank_weight
      t.integer :mandatory_weight
      t.boolean :disable_scheduler, :default => false
      t.integer :max_meetings_per_admit
    end
    rename_column :time_slots, :event_id, :settings_id
  end
end
