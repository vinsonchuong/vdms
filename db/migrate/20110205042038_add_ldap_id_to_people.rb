class AddLdapIdToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :ldap_id, :string
  end

  def self.down
    remove_column :people, :ldap_id
  end
end
