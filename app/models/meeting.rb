class Meeting < ActiveRecord::Base
  ATTRIBUTES = {
    'Time' => :time,
    'Room' => :room
  }

  belongs_to :faculty
  has_and_belongs_to_many :admits
end
