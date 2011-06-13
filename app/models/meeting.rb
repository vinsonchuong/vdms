class Meeting < ActiveRecord::Base
  # Notes and To-Do
  # - Add ranking checks as warnings (see http://stackoverflow.com/questions/3342449/activerecord-replace-model-validation-error-with-warning)
  # - Remove assumption of single day events or remove "from time1 to time2" entirely
  # - Pull scheduler into namespaced module

  attr_accessible :host_time_slot, :host_time_slot_id, :visitor_time_slot, :visitor_time_slot_id

  belongs_to :host_time_slot
  belongs_to :visitor_time_slot

  after_save :reset_associations

  validates_associated :host_time_slot
  validates_associated :visitor_time_slot
  validate :time_slots, :if => Proc.new {|m| m.errors[:host_time_slot].blank? && m.errors[:visitor_time_slot].blank?}
  validate :meeting_caps, :if => Proc.new {|m| m.errors[:host_time_slot].blank? && m.errors[:visitor_time_slot].blank?}
  validate :conflicts, :if => Proc.new {|m| m.errors[:host_time_slot].blank? && m.errors[:visitor_time_slot].blank?}

  def self.generate
    MeetingsScheduler.delete_old_meetings!
    MeetingsScheduler.create_meetings_from_ranking_scores!
  end

  def host
    host_time_slot.host
  end

  def visitor
    visitor_time_slot.visitor
  end

  def time
    (host_time_slot.begin)..(host_time_slot.end)
  end

  def room
    host_time_slot.room
  end

  # Callbacks
  def reset_associations
    host_time_slot.meetings.reset
    host.meetings.reset
    visitor_time_slot.meetings.reset
    visitor.meetings.reset
  end

  # Validations
  def time_slots
    errors.add_to_base :time_slots_must_match unless host_time_slot.same_time?(visitor_time_slot)
    errors.add(
      :host_time_slot,
      :not_available,
      :name => host.name,
      :begin => time.begin.strftime('%I:%M%p'),
      :end => time.end.strftime('%I:%M%p')
    ) unless host_time_slot.available?
    errors.add(
      :visitor_time_slot,
      :not_available,
      :name => visitor.name,
      :begin => time.begin.strftime('%I:%M%p'),
      :end => time.end.strftime('%I:%M%p')
    ) unless visitor_time_slot.available?
  end

  def meeting_caps
    errors.add(
      :host_time_slot,
      :per_meeting_cap_exceeded,
      :name => host.name,
      :max => host.max_admits_per_meeting
    ) if host_time_slot.meetings.count >= host.max_admits_per_meeting
  end

  def conflicts
    meeting = visitor_time_slot.meetings.detect {|m| m != self}
    errors.add(
      :visitor_time_slot,
      :conflict,
      :visitor_name => visitor.name,
      :host_name => meeting.host.name,
      :begin => meeting.time.begin.strftime('%I:%M%p'),
      :end => meeting.time.end.strftime('%I:%M%p')
    ) unless meeting.nil?
  end
end
