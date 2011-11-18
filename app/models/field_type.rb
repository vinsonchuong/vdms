class FieldType < ActiveRecord::Base
  def after_initialize
    self.options ||= {}
    self.extend self.data_type_module::FieldType unless self.data_type_module.nil?
  end
  after_create :create_fields

  belongs_to :event
  has_many :fields, :dependent => :destroy

  attr_readonly :data_type
  serialize :options, Hash

  validates_presence_of :name
  validates_presence_of :data_type
  validate :existence_of_data_type

  def self.data_types_list
    {
      'text' => 'Text',
      'single_select' => 'Single Selection'
    }
  end

  def data_type_module
    data_type.blank? ?
      nil :
      "DataTypes/#{data_type}".camelize.constantize
  rescue NameError
    nil
  end

  private

  def existence_of_data_type
    errors.add(:data_type, 'There is no such data type') unless self.class.data_types_list.include?(data_type)
  end
end
