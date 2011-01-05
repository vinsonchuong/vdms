class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :calnet_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :type

      # Faculty
      t.string :area
      t.string :division
      t.string :schedule
      t.string :default_room
      t.integer :max_admits_per_meeting
      t.integer :max_additional_admits

      # Admit
      t.string :phone
      t.string :area1
      t.string :area2
      t.boolean :attending
      t.string :available_times
      t.integer :peer_advisor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
