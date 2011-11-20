class RemoveAreaAndDivisionFromPeople < ActiveRecord::Migration
  def self.up
    remove_column :people, :area_1
    remove_column :people, :area_2
    remove_column :people, :area_3
    remove_column :people, :division
  end

  def self.down
    add_column :people, :area_1, :string
    add_column :people, :area_2, :string
    add_column :people, :area_3, :string
    add_column :people, :division, :string
  end
end
