class Person < ActiveRecord::Base
  has_many :event_roles , :class_name => 'Role'
  has_many :events, :through => :event_roles, :class_name => 'Settings'

  validates_presence_of :name
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  validates_inclusion_of :role, :in => ['user', 'facilitator', 'administrator']

  validate :division_inclusion
  validate :area_inclusion

  after_validation do |record| # Map Area and Division to their canonical forms
    areas = record.class.areas.invert
    divisions = record.class.divisions.invert
    record.area_1 = areas[record.area_1] unless record.area_1.nil? || areas[record.area_1].nil?
    record.area_2 = areas[record.area_2] unless record.area_2.nil? || areas[record.area_2].nil?
    record.area_3 = areas[record.area_3] unless record.area_3.nil? || areas[record.area_3].nil?
    record.division = divisions[record.division] unless record.division.nil? || divisions[record.division].nil?
  end

  default_scope :order => 'name'
  named_scope :with_areas, lambda {|*areas| {
      :conditions => ['area_1 IN(?) or area_2 IN(?) or area_3 IN (?)', areas, areas, areas]
  }}

  def self.areas
    STATIC_SETTINGS['areas']
  end

  def self.divisions
    STATIC_SETTINGS['divisions']
  end

  def areas
    [area1, area2, area3].reject(&:blank?)
  end

  def division_inclusion
    errors.add :division, :invalid unless division.blank? || self.class.divisions.to_a.flatten.include?(division)
  end

  def area_inclusion
    errors.add :area_1 unless area_1.blank? || self.class.areas.to_a.flatten.include?(area_1)
    errors.add :area_2 unless area_2.blank? || self.class.areas.to_a.flatten.include?(area_2)
    errors.add :area_3 unless area_3.blank? || self.class.areas.to_a.flatten.include?(area_3)
  end
end
