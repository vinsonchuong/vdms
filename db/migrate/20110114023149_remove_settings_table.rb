class RemoveSettingsTable < ActiveRecord::Migration
  def self.up
    remove_index :settings, :column => [ :target_type, :target_id, :var ]
    drop_table :settings
  end

  def self.down
    create_table :settings, :force => true do |t|
      t.string :var, :null => false
      t.text   :value, :null => true
      t.integer :target_id, :null => true
      t.string :target_type, :limit => 30, :null => true
      t.timestamps
    end
    
    add_index :settings, [ :target_type, :target_id, :var ], :unique => true
  end
end
