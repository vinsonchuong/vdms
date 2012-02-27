class Host < Role
  has_many :fields, :class_name => 'HostField', :foreign_key => 'role_id', :dependent => :destroy
  has_many :rankings, :class_name => 'HostRanking', :foreign_key => 'ranker_id', :dependent => :destroy
  has_many :ranked_visitors, :source => :rankable, :through => :rankings
  has_many :ranked_one_on_one_visitors, :source => :rankable, :through => :rankings, :conditions => ['rankings.one_on_one = ?', true]
  has_many :mandatory_visitors, :source => :rankable, :through => :rankings, :conditions => ['rankings.mandatory = ?', true]
  has_many :visitor_rankings, :foreign_key => 'rankable_id', :dependent => :destroy
  has_many :availabilities, :class_name => 'HostAvailability', :foreign_key => 'schedulable_id', :dependent => :destroy
  has_many :meetings, :through => :availabilities

  accepts_nested_attributes_for :fields #, :reject_if => proc {|a| a['fields'] == blah blah}
  accepts_nested_attributes_for :availabilities, :reject_if => :all_blank
  accepts_nested_attributes_for :rankings, :reject_if => proc {|attr| attr['rank'].blank?}, :allow_destroy => true

  default_scope(
      includes(:person)
        .joins(:person)
        .order('last_name', 'first_name')
        .readonly(false)
  )

  validates_presence_of :default_room
  validates_presence_of :max_visitors_per_meeting
  validates_numericality_of :max_visitors_per_meeting, :only_integer => true, :greater_than => 0
  validates_presence_of :max_visitors
  validates_numericality_of :max_visitors, :only_integer => true, :greater_than_or_equal_to => 0
  validate do |record| # uniqueness of ranks in rankings
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
        self.location
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

  def available_at?(time)
    availabilities.any?{ |a| a.time_slot.begin == time and a.available? }
    # incorrect code
    # time_slots.map(&:begin).include?(time)
  end

  def room_for(time)
    availability = availabilities.detect {|a| a.time_slot && a.time_slot.begin == time}
    availability.nil? ?
        default_room :
        availability.room.blank? ?
            default_room :
            availability.room
  end

  def self.attending_faculties
    Host.all.select {|faculty| faculty.time_slots.select {|time_slot| time_slot.available?}.count > 0}
  end

  private

  def create_availabilities
    event.time_slots.each {|t| availabilities.create(:time_slot => t, :available => false)}
  end
end
