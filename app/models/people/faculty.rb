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
      self.max_additional_admits ||= Float::MAX.to_i
    end
  end

  has_many :admit_rankings, :dependent => :destroy
  has_many :meetings, :dependent => :destroy

  validates_presence_of :area
  validates_inclusion_of :division, :in => Settings.instance.divisions.map(&:name)
  validates_presence_of :default_room
  validates_presence_of :max_admits_per_meeting
  validates_numericality_of :max_admits_per_meeting, :only_integer => true, :greater_than => 0
  validates_presence_of :max_additional_admits
  validates_numericality_of :max_additional_admits, :only_integer => true, :greater_than_or_equal_to => 0
end
