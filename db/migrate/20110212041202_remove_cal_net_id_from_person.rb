class RemoveCalNetIdFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :calnet_id
  end

  def self.down
    add_column :people, :calnet_id, :string
  end
end
