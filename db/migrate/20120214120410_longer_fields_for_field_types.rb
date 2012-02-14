class LongerFieldsForFieldTypes < ActiveRecord::Migration
  def change
    change_column :field_types, :options, :text
    change_column :fields, :data, :text
    change_column :features, :options, :text
  end
end
