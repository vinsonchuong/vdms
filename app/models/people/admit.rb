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

  after_create do |record|
    record.create_visitor(:event => Settings.instance)
  end
  after_validation do |record| # Map Areas to their canonical forms
    areas = Settings.instance.areas.invert
    record.area1 = areas[record.area1] unless record.area1.nil? || areas[record.area1].nil?
    record.area2 = areas[record.area2] unless record.area2.nil? || areas[record.area2].nil?
    record.area3 = areas[record.area3] unless record.area3.nil? || areas[record.area3].nil?
  end

  has_one :visitor, :foreign_key => 'person_id'

  named_scope :with_areas, lambda {|*areas| {
      :conditions => ['area1 IN(?) or area2 IN(?)', areas, areas],
      :order => 'last_name, first_name'
  }}

  validates_inclusion_of :area1, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area2, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area3, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
end
