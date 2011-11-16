class FieldType < ActiveRecord::Base
  belongs_to :event

  serialize :options, Hash
  validates_inclusion_of :data_type, :in => DataTypes.constants.map(&:to_s)
end
