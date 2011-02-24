class AvailableTime < ActiveRecord::Base
  belongs_to :schedulable, :polymorphic => true

  validates_datetime :begin
  validates_datetime :end
  validate do |record| # Beginning precedes End
    if !record.begin.nil? && !record.end.nil? && record.begin >= record.end
      record.errors.add_to_base('The beginning must precede the ending')
    end
  end
  validates_existence_of :schedulable

  def overlap?(other)
    (self.begin != other.end && self.end != other.begin) &&
    (
      (self.begin >= other.begin && self.begin <= other.end) ||
      (self.end >= other.begin && self.end <= other.end) ||
      (self.begin <= other.begin && self.end >= other.end)
    )
  end
end
