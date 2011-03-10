class AddWeightsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :admit_weight, :integer
    add_column :settings, :faculty_weight, :integer
    add_column :settings, :rank_weight, :integer
    add_column :settings, :mandatory_weight, :integer
  end

  def self.down
    remove_column :settings, :admit_weight
    remove_column :settings, :faculty_weight
    remove_column :settings, :rank_weight
    remove_column :settings, :mandatory_weight
  end
end
