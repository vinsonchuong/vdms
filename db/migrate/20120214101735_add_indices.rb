class AddIndices < ActiveRecord::Migration
  def up
    add_index :people, :email
    add_index :roles, :person_id
  end

  def down
    remove_index :people, :email
    remove_index :roles, :person_id
  end
end
