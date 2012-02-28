class AddBuildingList < ActiveRecord::Migration
  def change
    add_column :roles, :default_building, :string
    add_column :availabilities, :building, :string
  end
end
