class RemovePeerAdvisorBelongsTo < ActiveRecord::Migration
  def self.up
    remove_column :people, :peer_advisor_id
  end

  def self.down
    add_column :people, :peer_advisor_id, :integer
  end
end
