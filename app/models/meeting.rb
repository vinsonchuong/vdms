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
  default_scope order('score DESC')

  after_save :reset_associations

  validates_associated :host_availability
  validates_associated :visitor_availability
  validate :time_slots, :if => Proc.new {|m| m.errors[:host_availability].blank? && m.errors[:visitor_availability].blank?}
  validate :meeting_caps, :if => Proc.new {|m| m.errors[:host_availability].blank? && m.errors[:visitor_availability].blank?}
  validate :conflicts, :if => Proc.new {|m| m.errors[:host_availability].blank? && m.errors[:visitor_availability].blank?}

  #def self.generate
  #  MeetingsScheduler.delete_old_meetings!
  #  MeetingsScheduler.create_meetings_from_ranking_scores!
  #end

  ### Meeting Generator for CS 260 ###
  def self.generate(event)
    Meeting.select {|m| m.host.event == event}.each(&:destroy)
    pairings = event.hosts
      .product(event.visitors)
      .select {|p| self.satisfies_constraints?(event, p[0], p[1])}
      .map {|p| p + [self.score_pairing(event, p[0], p[1])]}
      .sort {|p, q| q[2] <=> p[2]}

    host_availabilities_lookup = {}
    event.hosts.each do |host|
      availabilities_lookup = host_availabilities_lookup[host] = {}
      host.availabilities.select(&:available?)
        .each {|a| availabilities_lookup[a] = true}
    end
    visitor_availabilities_lookup = {}
    event.visitors.each do |visitor|
      availabilities_lookup = visitor_availabilities_lookup[visitor] = {}
      visitor.availabilities.select(&:available?)
      .each {|a| availabilities_lookup[a] = true}
    end
    pairings.each do |host, visitor, score|
      next if host_availabilities_lookup[host].empty? or visitor_availabilities_lookup[visitor].empty?
      host_availability, visitor_availability = self.find_matching_availabilities(
                                                  event,
                                                  host_availabilities_lookup[host].keys,
                                                  visitor_availabilities_lookup[visitor].keys
                                                )
      next if host_availability.nil? or visitor_availability.nil?
      Meeting.create(
        :host_availability => host_availability,
        :visitor_availability => visitor_availability,
        :score => score
      )
      host_availabilities_lookup[host].delete(host_availability)
      visitor_availabilities_lookup[visitor].delete(visitor_availability)
    end
    return
  end

  def self.satisfies_constraints?(event, host, visitor)
    event.constraints.each do |constraint|
      host_field = host.fields.find_by_field_type_id(constraint.host_field_type_id)
      visitor_field = visitor.fields.find_by_field_type_id(constraint.visitor_field_type_id)
      return false if host_field.data.nil? or visitor_field.data.nil?
      case constraint.feature_type
        when 'equal'
          return false if host_field.data != visitor_field.data
        when 'not_equal'
          return false if host_field.data == visitor_field.data
        when 'intersect'
          host_field_data = host_field.data.class == Array ? host_field.data : [host_field.data]
          visitor_field_data = visitor_field.data.class == Array ? visitor_field.data : [visitor_field.data]
          return false if (host_field_data & visitor_field.data).empty?
        when 'not_intersect'
          host_field_data = host_field.data.class == Array ? host_field.data : [host_field.data]
          visitor_field_data = visitor_field.data.class == Array ? visitor_field.data : [visitor_field.data]
          return false unless (host_field_data & visitor_field_data).empty?
        when 'combination'
          return false unless constraint.options['combinations'].include?('host_value' => host_field.data,
                                                                          'visitor_value' => visitor_field.data)
      end
    end
    true
  end

  def self.score_pairing(event, host, visitor)
    score = 0
    event.goals.each do |goal|
      host_field = host.fields.find_by_field_type_id(goal.host_field_type_id)
      visitor_field = visitor.fields.find_by_field_type_id(goal.visitor_field_type_id)
      next if host_field.data.nil? or visitor_field.data.nil?
      case goal.feature_type
        when 'equal'
          score += goal.weight if host_field.data == visitor_field.data
        when 'not_equal'
          score += goal.weight if host_field.data != visitor_field.data
        when 'intersect'
          host_field_data = host_field.data.class == Array ? host_field.data : [host_field.data]
          visitor_field_data = visitor_field.data.class == Array ? visitor_field.data : [visitor_field.data]
          score += goal.weight unless (host_field_data & visitor_field_data).empty?
        when 'not_intersect'
          host_field_data = host_field.data.class == Array ? host_field.data : [host_field.data]
          visitor_field_data = visitor_field.data.class == Array ? visitor_field.data : [visitor_field.data]
          score += goal.weight if (host_field_data & visitor_field_data).empty?
        when 'combination'
          score += goal.weight if goal.options['combinations'].include?('host_value' => host_field.data,
                                                                        'visitor_value' => visitor_field.data)
      end
    end
    score
  end

  def self.find_matching_availabilities(event, host_availabilities, visitor_availabilities)
    time_slot = (host_availabilities.map(&:time_slot) & visitor_availabilities.map(&:time_slot)).first
    host_availability = host_availabilities.detect {|a| a.time_slot == time_slot}
    visitor_availability = visitor_availabilities.detect {|a| a.time_slot == time_slot}
    [host_availability, visitor_availability]
  end
  ### Meeting Generator for CS 260 ###

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

  def as_json(options = {})
    {
      id: id,
      host_id: host_availability.schedulable_id,
      visitor_id: visitor_availability.schedulable_id,
      time_slot_id: host_availability.time_slot_id,
      score: score
    }
  end
end
