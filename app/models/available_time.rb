class AvailableTime < ActiveRecord::Base
  ATTRIBUTES = {
    'Beginning' => :begin,
    'End' => :end,
    'Room' => :room
  }
  ATTRIBUTE_TYPES = {
    :begin => :time,
    :end => :time,
    :room => :string
  }

  belongs_to :schedulable, :polymorphic => true

  validates_datetime :begin
  validates_datetime :end
  validate do |record| # Beginning precedes End
    if !record.begin.nil? && !record.end.nil? && record.begin >= record.end
      record.errors.add_to_base('The beginning must precede the ending')
    end
  end
  validates_existence_of :schedulable

  def begin=(begin_time)
    begin_time = Time.parse(begin_time) if begin_time.class == String
    self.write_attribute(:begin, begin_time)
  end

  def end=(end_time)
    end_time = Time.parse(end_time) if end_time.class == String
    self.write_attribute(:end, end_time)
  end

  def overlap?(other)
    (self.begin != other.end && self.end != other.begin) &&
    (
      (self.begin >= other.begin && self.begin <= other.end) ||
      (self.end >= other.begin && self.end <= other.end) ||
      (self.begin <= other.begin && self.end >= other.end)
    )
  end
end
