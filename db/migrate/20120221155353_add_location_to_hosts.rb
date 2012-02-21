class AddLocationToHosts < ActiveRecord::Migration
  def change
    add_column :roles, :location, :text
    add_column :roles, :location_id, :text
  end
end
