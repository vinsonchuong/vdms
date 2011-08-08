class RefactorPerson < ActiveRecord::Migration
  def self.up
    drop_table :people
    create_table :people do |t|
      t.string :ldap_id
      t.string :name
      t.string :email
      t.string :role

      t.string :division
      t.string :area_1
      t.string :area_2
      t.string :area_3
    end
  end

  def self.down
    drop_table :people
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :type
      t.string :division
      t.string :area1
      t.string :area2
      t.string :area3
      t.string :ldap_id
    end
  end
end
