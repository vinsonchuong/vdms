class AddRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :person_id
      t.integer :event_id
      t.string :type

      t.string :default_room, :default => 'None'
      t.integer :max_visitors_per_meeting, :default => 4
      t.integer :max_visitors, :default => 100
    end
    remove_column :people, :default_room
    remove_column :people, :max_admits_per_meeting
    remove_column :people, :max_additional_admits
  end

  def self.down
    drop_table :roles
    add_column :people, :default_room, :string
    add_column :people, :max_admits_per_meeting, :integer
    add_column :people, :max_additional_admits, :integer
  end
end
