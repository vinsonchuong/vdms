class Faculty < Person
  include Schedulable

  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Area 1' => :area1,
    'Area 2' => :area2,
    'Area 3' => :area3,
    'Division' => :division,
    'Default Room' => :default_room,
    'Max Admits Per Meeting' => :max_admits_per_meeting,
    'Max Additional Admits' => :max_additional_admits
  })
  ATTRIBUTE_TYPES = Person::ATTRIBUTE_TYPES.merge({
    :area1 => :string,
    :area2 => :string,
    :area3 => :string,
    :division => :string,
    :default_room => :string,
    :max_admits_per_meeting => :integer,
    :max_additional_admits => :integer
  })

  after_create do |record|
    record.create_host(:event => Settings.instance)
  end
  after_validation do |record| # Map Area and Division to their canonical forms
    settings = Settings.instance
    areas = settings.areas.invert
    divisions = settings.divisions.invert
    record.area1 = areas[record.area1] unless record.area1.nil? || areas[record.area1].nil?
    record.area2 = areas[record.area2] unless record.area2.nil? || areas[record.area2].nil?
    record.area3 = areas[record.area3] unless record.area3.nil? || areas[record.area3].nil?
    record.division = divisions[record.division] unless record.division.nil? || divisions[record.division].nil?
  end

  has_one :host, :foreign_key => 'person_id'

  validates_presence_of :email
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  validates_inclusion_of :area1, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area2, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area3, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :division, :in => Settings.instance.divisions.to_a.flatten

  def area
    self.area1
  end

  def area=(new_area)
    self.area1 = new_area
  end
end
