class TimeSlot < ActiveRecord::Base
  attr_accessible :begin, :end, :settings, :settings_id

  belongs_to :settings
  has_many :host_availabilities, :dependent => :destroy
  has_many :visitor_availabilities, :dependent => :destroy

  default_scope :order => 'begin'

  validates_datetime :begin
  validates_datetime :end
  validates_datetime :end, :after => :begin
  validates_existence_of :settings

  def begin=(begin_time)
    if begin_time.class == String
      parsed = Time.zone.parse(begin_time)
      begin_time = parsed unless parsed.nil?
    end
    write_attribute(:begin, begin_time)
  end

  def end=(end_time)
    if end_time.class == String
      parsed = Time.zone.parse(end_time)
      end_time = parsed unless parsed.nil?
    end
    write_attribute(:end, end_time)
  end

  def same_time?(other)
    self.begin == other.begin && self.end == other.end
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
