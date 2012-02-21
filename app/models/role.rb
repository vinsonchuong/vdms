class Role < ActiveRecord::Base
  after_create :create_availabilities # add to spec

  belongs_to :person
  belongs_to :event
  accepts_nested_attributes_for :person, :update_only => true

  default_scope joins(:person).order('people.last_name', 'people.first_name').readonly(false)

  # add to spec
  validates_existence_of :person
  validates_existence_of :event

  scope :with_areas, lambda {|*areas|
    include(:person).where('area_1 IN(?) or area_2 IN(?) or area_3 IN (?)', areas, areas, areas).readonly(false)
  }

  def as_json(options = {})
    super(options.merge!(:include => [:person, :fields, :availabilities]))
  end

  def as_csv_row()
    data = [
        self.person.last_name,
        self.person.first_name,
        self.person.email,
        self.person.phone,
    ]
    self.fields.each do |field|
      item = field.data && field.data[:answer]
      item = item.join('; ') if item.is_a?(Array)
      data << item
    end
    data
  end
end
