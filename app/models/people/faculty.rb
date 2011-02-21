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

  after_validation do |record| # destroy available_times not flagged as available
    record.available_times.each {|t| t.destroy unless t.available}
  end

  has_many :admit_rankings, :order => 'rank ASC', :dependent => :destroy
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
    ranks = record.admit_rankings.map(&:rank)
    if ranks.count != ranks.uniq.count
      record.errors.add_to_base('Ranks must be unique')
    end
  end
end
