class AddGenericFields < ActiveRecord::Migration
  def self.up
    create_table :field_type do |t|
      t.string :name
      t.text :description
      t.string :data_type
      t.string :options
      t.string :type
      t.integer :event_id
    end

    create_table :field do |t|
      t.string :data
      t.string :type
      t.integer :host_id
      t.integer :host_field_type_id
      t.integer :visitor_id
      t.integer :visitor_field_type_id
    end
  end

  def self.down
    drop_table :field_type
    drop_table :field
  end
end
