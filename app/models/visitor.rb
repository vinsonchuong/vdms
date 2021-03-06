class Visitor < Role
  has_many :fields, :class_name => 'VisitorField', :foreign_key => 'role_id', :dependent => :destroy
  has_many :rankings, :class_name => 'VisitorRanking', :foreign_key => 'ranker_id', :dependent => :destroy
  has_many :ranked_hosts, :source => :rankable, :through => :rankings
  has_many :host_rankings, :foreign_key => 'rankable_id', :dependent => :destroy
  accepts_nested_attributes_for :rankings, :reject_if => proc {|attr| attr['rank'].blank?}, :allow_destroy => true
  has_many :availabilities, :class_name => 'VisitorAvailability', :foreign_key => 'schedulable_id', :dependent => :destroy
  has_many :meetings, :through => :availabilities

  accepts_nested_attributes_for :fields #, :reject_if => proc {|a| a['fields'] == blah blah}
  accepts_nested_attributes_for :availabilities, :reject_if => :all_blank, :allow_destroy => true

  default_scope(
      includes(:person)
        .joins(:person)
        .order('last_name', 'first_name')
        .readonly(false)
  )

  validate do |record| # uniqueness of ranks in faculty_rankings
    ranks = record.rankings.reject(&:marked_for_destruction?).map(&:rank)
    if ranks.count != ranks.uniq.count
      record.errors.add(:base, 'Ranks must be unique')
    end
  end

  def as_csv_row(spans)
    data = [
        self.person.last_name,
        self.person.first_name,
        self.person.email,
        self.person.phone,
    ]
    self.fields.each do |field|
      item = field.data && field.data[:answer]
      if ['hosts', 'visitors', 'multiple_select'].include? field.field_type.data_type
        item = [] if item.blank?
        if ['hosts', 'visitors'].include? field.field_type.data_type
          item.map! {|id| Role.find(id).person.name}
        end
        data.concat(item).concat([''] * (spans[field.field_type.name] - item.length))
      else
        data << item
      end
      if field.field_type.options['comment'] == 'yes'
        data << (field.data && !field.data[:comments].blank? ? field.data[:comments] : '')
      end
    end
    data
  end

  def meeting_at_time(time)
    meetings.find_by_time(time)
  end

  # Flagged for removal
  def available_at?(time)
    time_slots.any?{ |at| at.begin == time and at.available? }
    # incorrect code
    # time_slots.map(&:begin).include?(time)
  end

  def unsatisfied?
    meetings.collect{ |m| m.faculty_id }.uniq.count < Settings.instance.unsatisfied_admit_threshold
  end

  def maxed_out_number_of_meetings?
    meetings.collect{ |m| m.faculty_id }.uniq.count >= Settings.instance.max_meetings_per_admit
  end

  def self.attending_admits
    Admit.all.select{ |admit| admit.time_slots.select {|time_slot| time_slot.available?}.count > 0 }
  end

  def self.unsatisfied_admits
    # Also sort them by least meetings count first
    Admit.attending_admits.select{ |admit| admit.unsatisfied? }.sort_by{ |admit| admit.meetings.count }
  end

  private

  def create_availabilities
    # validate against duplicates
    event.time_slots.each {|t| availabilities.create(:time_slot => t, :available => true)}
  end
end
