class AddGoalsConstraints < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :name
      t.float :weight
      t.string :feature_type
      t.string :options
      t.string :type
      t.integer :event_id
      t.integer :host_field_type_id
      t.integer :visitor_field_type_id
    end
  end

  def self.down
    drop_table :features
  end
end
