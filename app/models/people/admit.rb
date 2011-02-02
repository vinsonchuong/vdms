class Admit < Person
  include Schedulable

  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Phone' => :phone,
    'Area 1' => :area1,
    'Area 2' => :area2,
  })
  ATTRIBUTE_TYPES = Person::ATTRIBUTE_TYPES.merge({
    :phone => :string,
    :area1 => :string,
    :area2 => :string,
  })

  after_validation do |record| # format Phone
    unless record.phone.nil?
      record.phone.gsub!(/^\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/, '(\1) \2-\3')
    end
  end

  belongs_to :peer_advisor
  has_many :faculty_rankings, :dependent => :destroy
  has_and_belongs_to_many :meetings, :uniq => true

  validates_presence_of :phone
  validates_format_of :phone, :with => /^\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,
    :message => 'must be a valid numeric US phone number'
  validates_presence_of :area1
  validates_presence_of :area2
  validates_existence_of :peer_advisor, :allow_nil => true
  
  def full_name
    self.first_name+" "+self.last_name
  end
  
end
