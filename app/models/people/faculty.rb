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
  after_validation do |record| # Map Area and Division to their canonical forms
    settings = Settings.instance
    areas = settings.areas.invert
    divisions = {}
    settings.divisions.each {|d| divisions[d.long_name] = d.name}
    record.area = areas[record.area] unless record.area.nil? || areas[record.area].nil?
    record.division = divisions[record.division] unless record.division.nil? || divisions[record.division].nil?
  end
  before_save do |record| # Maintain correspondence between available time slots and meeting slots
    available_times = record.available_times.select(&:available).map(&:begin)
    meeting_times = record.meetings.map(&:time)
    record.meetings.reject {|m| available_times.include?(m.time)}.each(&:destroy)
    (available_times - meeting_times).each do |time|
      record.meetings.create(:time => time, :room => record.room_for(time))
    end
    record.meetings.reload.each {|m| m.update_attributes(:room => record.room_for(m.time))}
  end

  has_many :admit_rankings, :order => 'rank ASC', :dependent => :destroy
  has_many :ranked_admits, :source => :admit, :through => :admit_rankings, :order => 'rank ASC'
  has_many :ranked_one_on_one_admits, :source => :admit, :through => :admit_rankings, :conditions => ['rankings.one_on_one = ?', true]
  has_many :mandatory_admits, :source => :admit, :through => :admit_rankings, :conditions => ['rankings.mandatory = ?', true]
  has_many :faculty_rankings, :dependent => :destroy
  has_many :meetings, :dependent => :destroy
  accepts_nested_attributes_for :admit_rankings, :reject_if => proc {|attr| attr['rank'].blank?}, :allow_destroy => true

  validates_presence_of :email
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  validates_inclusion_of :division, :in => (Settings.instance.divisions.map(&:name) + Settings.instance.divisions.map(&:long_name))
  validates_inclusion_of :area, :in => Settings.instance.areas.to_a.flatten
  validates_presence_of :default_room
  validates_presence_of :max_admits_per_meeting
  validates_numericality_of :max_admits_per_meeting, :only_integer => true, :greater_than => 0
  validates_presence_of :max_additional_admits
  validates_numericality_of :max_additional_admits, :only_integer => true, :greater_than_or_equal_to => 0
  validate do |record| # uniqueness of ranks in admit_rankings
    ranks = record.admit_rankings.reject(&:marked_for_destruction?).map(&:rank)
    if ranks.count != ranks.uniq.count
      record.errors.add_to_base('Ranks must be unique')
    end
  end
  
  def available_at?(time)
    available_times.map(&:begin).include?(time)
  end

  def room_for(time)
    available_time = available_times.detect {|t| t.begin == time}
    available_time.nil? ? default_room :
    available_time.room.blank? ? default_room :
    available_time.room
  end
  
  def self.attending_faculties
    Faculty.all.select {|faculty| faculty.available_times.select {|available_time| available_time.available?}.count > 0}
  end
end
