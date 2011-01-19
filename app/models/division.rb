class Division < ActiveRecord::Base
  ATTRIBUTES = {
    'Name' => :name
  }
  ATTRIBUTE_TYPES = {
    :name => :string
  }

  has_many :available_times, :as => :schedulable, :dependent => :destroy
  belongs_to :settings

  validate do |record| # non-overlapping Available Meeting Times
    record.available_times.combination(2) do |times|
      if times[0].overlap?(times[1])
        record.errors.add_to_base('Available times must not overlap')
        break
      end
    end
  end
  validates_existence_of :settings
end
