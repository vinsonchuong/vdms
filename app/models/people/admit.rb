class Admit < Person
  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Phone' => :phone,
    'Area 1' => :area1,
    'Area 2' => :area2,
    'Attending' => :attending,
  })
  ATTRIBUTE_TYPES = Person::ATTRIBUTE_TYPES.merge({
    :phone => :string,
    :area1 => :string,
    :area2 => :string,
    :attending => :boolean,
  })

  def after_initialize
    if self.new_record?
      self.attending ||= false
    end
  end
  after_validation do |record| # format Phone
    unless record.phone.nil?
      record.phone.gsub!(/^\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/, '(\1) \2-\3')
    end
  end

  belongs_to :peer_advisor
  has_many :available_times, :as => :schedulable, :dependent => :destroy
  has_many :faculty_rankings, :dependent => :destroy
  has_and_belongs_to_many :meetings, :uniq => true

  validates_presence_of :phone
  validates_format_of :phone, :with => /^\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,
    :message => 'must be a valid numeric US phone number'
  validates_presence_of :area1
  validates_presence_of :area2
  validates_inclusion_of :attending, :in => [true, false]
  validates_existence_of :peer_advisor, :allow_nil => true
  validate do |record| # non-overlapping Available Times
    record.available_times.combination(2) do |times|
      if times[0].overlap?(times[1])
        record.errors.add_to_base('Available times must not overlap')
        break
      end
    end
  end

  def self.attending_admits
    Admit.all.find_all{ |admit| admit.attending? }
  end
end
