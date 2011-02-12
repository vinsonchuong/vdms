class Admit < Person
  include Schedulable

  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Phone' => :phone,
    'Division' => :division,
    'Area 1' => :area1,
    'Area 2' => :area2
  })
  ATTRIBUTE_TYPES = Person::ATTRIBUTE_TYPES.merge({
    :phone => :string,
    :division => :string,
    :area1 => :string,
    :area2 => :string
  })

  after_validation do |record| # format Phone
    unless record.phone.nil?
      record.phone.gsub!(/^\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/, '(\1) \2-\3')
    end
  end

  belongs_to :peer_advisor
  has_many :faculty_rankings, :order => 'rank ASC', :dependent => :destroy
  accepts_nested_attributes_for :faculty_rankings, :reject_if => proc {|attr| attr['rank'].blank?}, :allow_destroy => true
  has_and_belongs_to_many :meetings, :uniq => true

  validates_presence_of :phone
  validates_format_of :phone, :with => /^\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,
    :message => 'must be a valid numeric US phone number'
  validates_inclusion_of :division, :in => Settings.instance.divisions.map(&:name)
  validates_inclusion_of :area1, :in => Settings.instance.areas
  validates_inclusion_of :area2, :in => Settings.instance.areas
  validates_existence_of :peer_advisor, :allow_nil => true
  validate do |record| # uniqueness of ranks in faculty_rankings
    ranks = record.faculty_rankings.map(&:rank)
    if ranks.count != ranks.uniq.count
      record.errors.add_to_base('Ranks must be unique')
    end
  end
end
