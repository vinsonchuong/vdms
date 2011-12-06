class AddScoreToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :score, :float
  end
end
