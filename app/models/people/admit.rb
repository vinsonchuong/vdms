class Admit < Person
  include Schedulable

  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Phone' => :phone,
    'Area 1' => :area1,
    'Area 2' => :area2,
    'Area 3' => :area3
  })
  ATTRIBUTE_TYPES = Person::ATTRIBUTE_TYPES.merge({
    :phone => :string,
    :area1 => :string,
    :area2 => :string,
    :area3 => :string
  })

  after_validation do |record| # Map Areas to their canonical forms
    areas = Settings.instance.areas.invert
    record.area1 = areas[record.area1] unless record.area1.nil? || areas[record.area1].nil?
    record.area2 = areas[record.area2] unless record.area2.nil? || areas[record.area2].nil?
    record.area3 = areas[record.area3] unless record.area3.nil? || areas[record.area3].nil?
  end
  after_create do |record|
    # validate against duplicates
    Settings.instance.time_slots.each do |time_slot|
      record.availabilities.create(:time_slot => time_slot, :available => true)
    end
  end

  has_many :rankings, :class_name => 'VisitorRanking', :foreign_key => 'ranker_id', :dependent => :destroy
  has_many :ranked_hosts, :source => :rankable, :through => :rankings
  has_many :host_rankings, :foreign_key => 'rankable_id', :dependent => :destroy
  accepts_nested_attributes_for :rankings, :reject_if => proc {|attr| attr['rank'].blank?}, :allow_destroy => true
  has_many :availabilities, :class_name => 'VisitorAvailability', :foreign_key => 'schedulable_id', :dependent => :destroy
  has_many :meetings, :through => :availabilities
  accepts_nested_attributes_for :availabilities, :reject_if => :all_blank, :allow_destroy => true

  validates_inclusion_of :area1, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area2, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area3, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validate do |record| # uniqueness of ranks in faculty_rankings
    ranks = record.rankings.reject(&:marked_for_destruction?).map(&:rank)
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

  # Flagged for removal
  def available_at?(time)
    time_slots.any?{ |at| at.begin == time and at.available? }
    # incorrect code
    # time_slots.map(&:begin).include?(time)
  end

  def unsatisfied?
    meetings.collect{ |m| m.faculty_id }.uniq.count < Settings.instance.unsatisfied_admit_threshold
  end

  def maxed_out_number_of_meetings?
    meetings.collect{ |m| m.faculty_id }.uniq.count >= Settings.instance.max_meetings_per_admit
  end
  
  def self.attending_admits
    Admit.all.select{ |admit| admit.time_slots.select {|time_slot| time_slot.available?}.count > 0 }
  end

  def self.unsatisfied_admits
    # Also sort them by least meetings count first
    Admit.attending_admits.select{ |admit| admit.unsatisfied? }.sort_by{ |admit| admit.meetings.count }
  end
end
