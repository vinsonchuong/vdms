class Admit < Person
  include Schedulable

  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Phone' => :phone,
    'Area 1' => :area1,
    'Area 2' => :area2
  })
  ATTRIBUTE_TYPES = Person::ATTRIBUTE_TYPES.merge({
    :phone => :string,
    :area1 => :string,
    :area2 => :string
  })

  after_validation do |record| # Map Areas to their canonical forms
    areas = Settings.instance.areas.invert
    record.area1 = areas[record.area1] unless record.area1.nil? || areas[record.area1].nil?
    record.area2 = areas[record.area2] unless record.area2.nil? || areas[record.area2].nil?
  end

  has_many :faculty_rankings, :order => 'rank ASC', :dependent => :destroy
  has_many :admit_rankings, :dependent => :destroy
  accepts_nested_attributes_for :faculty_rankings, :reject_if => proc {|attr| attr['rank'].blank?}, :allow_destroy => true
  has_and_belongs_to_many :meetings, :uniq => true

  validates_inclusion_of :area1, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area2, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validate do |record| # uniqueness of ranks in faculty_rankings
    ranks = record.faculty_rankings.reject(&:marked_for_destruction?).map(&:rank)
    if ranks.count != ranks.uniq.count
      record.errors.add_to_base('Ranks must be unique')
    end
  end

  named_scope :with_areas, lambda {|*areas| {
    :conditions => ['area1 IN(?) or area2 IN(?)', areas, areas],
    :order => 'last_name, first_name'
  }}

  def meeting_at_time(time)
    meetings.find_by_time(time)
  end

  def available_at?(time)
    available_times.map(&:begin).include?(time)
  end
  
  def self.attending_admits
    Admit.all.select {|admit| admit.available_times.select {|available_time| available_time.available?}.count > 0 }
  end
end
