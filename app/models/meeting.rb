class Meeting < ActiveRecord::Base
  # Notes and To-Do
  # - Add ranking checks as warnings (see http://stackoverflow.com/questions/3342449/activerecord-replace-model-validation-error-with-warning)
  # - Remove assumption of single day events or remove "from time1 to time2" entirely
  # - Pull scheduler into namespaced module

  #attr_accessible :host_availability, :host_availability_id, :visitor_availability, :visitor_availability_id

  belongs_to :host_availability
  belongs_to :visitor_availability

  scope :by_host, joins(:host_availability => {:schedulable => :person}).order('name').readonly(false)
  scope :by_visitor, joins(:visitor_availability => {:schedulable => :person}).order('name').readonly(false)

  after_save :reset_associations

  validates_associated :host_availability
  validates_associated :visitor_availability
  validate :time_slots, :if => Proc.new {|m| m.errors[:host_availability].blank? && m.errors[:visitor_availability].blank?}
  validate :meeting_caps, :if => Proc.new {|m| m.errors[:host_availability].blank? && m.errors[:visitor_availability].blank?}
  validate :conflicts, :if => Proc.new {|m| m.errors[:host_availability].blank? && m.errors[:visitor_availability].blank?}

  def self.generate
    MeetingsScheduler.delete_old_meetings!
    MeetingsScheduler.create_meetings_from_ranking_scores!
  end

  def host
    host_availability && host_availability.schedulable
  end

  def visitor
    visitor_availability && visitor_availability.schedulable
  end

  def time
    (host_availability.time_slot.begin)..(host_availability.time_slot.end)
  end

  def room
    host_availability.room
  end

  # Callbacks
  def reset_associations
    host_availability.meetings.reset
    host.meetings.reset
    visitor_availability.meetings.reset
    visitor.meetings.reset
  end

  # Validations
  def time_slots
    errors.add :base, :time_slots_must_match unless host_availability.time_slot == visitor_availability.time_slot
    errors.add(
      :host_availability,
      :not_available,
      :name => host.person.name,
      :begin => time.begin.strftime('%I:%M%p'),
      :end => time.end.strftime('%I:%M%p')
    ) unless host_availability.available?
    errors.add(
      :visitor_availability,
      :not_available,
      :name => visitor.person.name,
      :begin => time.begin.strftime('%I:%M%p'),
      :end => time.end.strftime('%I:%M%p')
    ) unless visitor_availability.available?
  end

  def meeting_caps
    errors.add(
      :host_availability,
      :per_meeting_cap_exceeded,
      :name => host.person.name,
      :max => host.max_visitors_per_meeting
    ) if host_availability.meetings.count >= host.max_visitors_per_meeting
  end

  def conflicts
    meeting = visitor_availability.meetings.detect {|m| m != self}
    errors.add(
      :visitor_availability,
      :conflict,
      :visitor_name => visitor.person.name,
      :host_name => meeting.host.person.name,
      :begin => meeting.time.begin.strftime('%I:%M%p'),
      :end => meeting.time.end.strftime('%I:%M%p')
    ) unless meeting.nil?
  end
end
