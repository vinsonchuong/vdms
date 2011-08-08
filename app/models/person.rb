class Person < ActiveRecord::Base
  has_many :event_roles , :class_name => 'Role'
  has_many :events, :through => :event_roles, :class_name => 'Settings'

  validates_presence_of :name
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i, :allow_blank => true
  validates_inclusion_of :role, :in => ['user', 'facilitator', 'administrator']
  validates_inclusion_of :division, :in => Settings.instance.divisions.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area_1, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area_2, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true
  validates_inclusion_of :area_3, :in => Settings.instance.areas.to_a.flatten, :allow_blank => true

  after_validation do |record| # Map Area and Division to their canonical forms
    settings = Settings.instance
    areas = settings.areas.invert
    divisions = settings.divisions.invert
    record.area_1 = areas[record.area_1] unless record.area_1.nil? || areas[record.area_1].nil?
    record.area_2 = areas[record.area_2] unless record.area_2.nil? || areas[record.area_2].nil?
    record.area_3 = areas[record.area_3] unless record.area_3.nil? || areas[record.area_3].nil?
    record.division = divisions[record.division] unless record.division.nil? || divisions[record.division].nil?
  end

  default_scope :order => 'name'
  named_scope :with_areas, lambda {|*areas| {
      :conditions => ['area_1 IN(?) or area_2 IN(?) or area_3 IN (?)', areas, areas, areas]
  }}

  def areas
    [area1, area2, area3].reject(&:blank?)
  end
end
