class Role < ActiveRecord::Base
  after_create :create_availabilities # add to spec

  belongs_to :person
  belongs_to :event
  accepts_nested_attributes_for :person, :update_only => true

  # add to spec
  validates_existence_of :person
  validates_existence_of :event

  default_scope joins(:person).order('name').readonly(false)
  scope :with_areas, lambda {|*areas|
    joins(:person).where('area_1 IN(?) or area_2 IN(?) or area_3 IN (?)', areas, areas, areas)
  }

  def as_json(options = {})
    super(options.merge!(:include => [:person, :fields]))
  end
end
