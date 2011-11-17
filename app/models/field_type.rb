class FieldType < ActiveRecord::Base
  def after_initialize
    if self.new_record?
      self.options = {}
    end
  end

  belongs_to :event

  attr_readonly :data_type
  serialize :options, Hash

  validates_presence_of :name
  validates_presence_of :data_type
  validate :existence_of_data_type

  def data_type_module
    data_type.blank? ?
      nil :
      "DataTypes/#{data_type}".camelize.constantize
  rescue NameError
    nil
  end

  private

  def existence_of_data_type
    "DataTypes/#{data_type}".camelize.constantize
  rescue NameError
    errors.add(:data_type, 'There is no such data type')
  end
end
