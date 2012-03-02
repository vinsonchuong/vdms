class ChangeHostDefaults < ActiveRecord::Migration
  def up
    change_column :roles, :max_visitors_per_meeting, :integer, :default => 1
    change_column :roles, :max_visitors, :integer, :default => 10
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
