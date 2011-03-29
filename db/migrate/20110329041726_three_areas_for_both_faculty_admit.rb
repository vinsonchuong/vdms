class ThreeAreasForBothFacultyAdmit < ActiveRecord::Migration
  def self.up
    rename_column :people, :area1, :area3
    rename_column :people, :area, :area1
  end

  def self.down
    rename_column :people, :area1, :area
    rename_column :people, :area3, :area1
  end
end
