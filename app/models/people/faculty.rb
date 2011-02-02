class Faculty < Person
  include Schedulable

  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Area' => :area,
    'Division' => :division,
    'Default Room' => :default_room,
    'Max Admits Per Meeting' => :max_admits_per_meeting,
    'Max Additional Admits' => :max_additional_admits
  })
  ATTRIBUTE_TYPES = Person::ATTRIBUTE_TYPES.merge({
    :area => :string,
    :division => :string,
    :default_room => :string,
    :max_admits_per_meeting => :integer,
    :max_additional_admits => :integer
  })

  def after_initialize
    if self.new_record?
      self.default_room ||= 'None'
      self.max_admits_per_meeting ||= 1
      self.max_additional_admits ||= 100
    end
  end
  after_validation do |record| # destroy available_times not flagged as available
    record.available_times.each {|t| t.destroy unless t.available}
  end

  has_many :admit_rankings, :dependent => :destroy
  has_many :meetings, :dependent => :destroy
  accepts_nested_attributes_for :admit_rankings, :allow_destroy => true, :reject_if => :all_blank
  
  
  validates_presence_of :area
  validates_inclusion_of :division, :in => Settings.instance.divisions.map(&:name)
  validates_presence_of :default_room
  validates_presence_of :max_admits_per_meeting
  validates_numericality_of :max_admits_per_meeting, :only_integer => true, :greater_than => 0
  validates_presence_of :max_additional_admits
  validates_numericality_of :max_additional_admits, :only_integer => true, :greater_than_or_equal_to => 0

  def build_available_times
    settings = Settings.instance
    times = RangeSet.new(settings.meeting_times(self.division).map {|t| (t.begin)..(t.end)}) -
            RangeSet.new(self.available_times.map {|t| (t.begin)..(t.end + settings.meeting_gap)})
    times.each_range do |range|
      range.step(settings.meeting_length + settings.meeting_gap) do |start|
        if start + settings.meeting_length <= range.end
          self.available_times.build(:begin => start, :end => start + settings.meeting_length)
        end
      end
    end
    self.available_times.sort! {|x, y| x.begin <=> y.begin}
  end
end
