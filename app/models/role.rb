class Role < ActiveRecord::Base
  belongs_to :person
  belongs_to :event, :class_name => 'Settings'

  # add to spec
  validates_existence_of :person
  validates_existence_of :event

  default_scope :joins => :person, :order => 'last_name, first_name'
  named_scope :with_areas, lambda {|*areas| {
    :joins => :person,
    :conditions => ['area1 IN(?) or area2 IN(?)', areas, areas]
  }}
end