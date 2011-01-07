class Meeting < ActiveRecord::Base
  ATTRIBUTES = {
    'Time' => :time,
    'Room' => :room
  }

  validates_datetime :time
  validates_presence_of :room
  validates_existence_of :faculty

  belongs_to :faculty
  has_and_belongs_to_many :admits
end
