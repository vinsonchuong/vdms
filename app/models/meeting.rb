class Meeting < ActiveRecord::Base
=begin
  Attributes
    time
    room
=end

  belongs_to :faculty
  has_and_belongs_to_many :admits
end
