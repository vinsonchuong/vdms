class Admit < Person
  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Phone' => :phone,
    'Area 1' => :area1,
    'Area 2' => :area2,
    'Attending' => :attending,
    'Available Times' => :available_times
  })
  ATTRIBUTE_TYPES = Person::ATTRIBUTE_TYPES.merge({
    :phone => :string,
    :area1 => :string,
    :area2 => :string,
    :attending => :boolean,
    :available_times => :range_set
  })
  serialize :available_times, RangeSet

  def after_initialize
    if new_record? # work around for bug 3165
      self.attending ||= false
      self.available_times ||= RangeSet.new
    end
  end
  after_validation :format_phone

  validates_presence_of :phone
  validates_format_of :phone, :with => /^\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,
    :message => 'must be a valid numeric US phone number'
  validates_presence_of :area1
  validates_presence_of :area2
  validates_inclusion_of :attending, :in => [true, false]
  validates_existence_of :peer_advisor, :allow_nil => true

  belongs_to :peer_advisor
  has_many :faculty_rankings, :dependent => :destroy
  has_and_belongs_to_many :meetings, :uniq => true

  def format_phone
    unless self.phone.nil?
      self.phone.gsub!(/^\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/, '(\1) \2-\3')
    end
  end
end
