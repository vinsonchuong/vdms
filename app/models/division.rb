class Division < ActiveRecord::Base
  include Schedulable

  ATTRIBUTES = {
    'Name' => :name
  }
  ATTRIBUTE_TYPES = {
    :name => :string
  }

  belongs_to :settings

  validates_existence_of :settings
end
