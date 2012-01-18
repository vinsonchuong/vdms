class AddDisableMeetingLocationOverrideFlag < ActiveRecord::Migration
  def up
    add_column :events, :disable_meeting_location_override, :boolean, :default => false
  end

  def down
    remove_column :events, :disable_meeting_location_override
  end
end
