class AddOrderToFieldTypes < ActiveRecord::Migration
  def change
    add_column :field_types, :sort_order, :integer
  end
end
