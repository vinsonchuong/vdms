class Division < ActiveRecord::Base
  include Schedulable

  belongs_to :settings

  validates_existence_of :settings
end
