class AddGenericFields < ActiveRecord::Migration
  def self.up
    create_table :field_types do |t|
      t.string :name
      t.text :description
      t.string :data_type
      t.string :options
      t.string :type
      t.integer :event_id
    end

    create_table :fields do |t|
      t.string :data
      t.string :type
      t.integer :role_id
      t.integer :field_type_id
    end
  end

  def self.down
    drop_table :field_types
    drop_table :fields
  end
end
