class FieldType < ActiveRecord::Base
  after_initialize :include_field_type_module
  after_initialize :set_defaults
  after_create :create_fields

  belongs_to :event
  has_many :fields, :dependent => :destroy

  serialize :options, Hash

  validates_presence_of :name
  validates_presence_of :data_type
  validate :existence_of_data_type

  default_scope order('sort_order')

  def self.data_types_list
    {
      'text' => 'Text',
      'single_select' => 'Single Selection',
      'multiple_select' => 'Multiple Selection',
      'boolean' => 'Yes / No',
      'number' => 'Number',
      'number_range' => 'Range of Numbers',
      'location' => 'Location',
      'hosts' => 'List of Hosts',
      'visitors' => 'List of Visitors'
    }
  end

  def data_type_module
    data_type.blank? ?
      nil :
      "data_types/#{data_type}".camelize.constantize
  rescue NameError
    nil
  end

  private

  def set_defaults
    self.options ||= {}
  end

  def include_field_type_module
    extend data_type_module::FieldType unless data_type_module.nil?
  end

  def existence_of_data_type
    errors.add(:data_type, 'There is no such data type') unless self.class.data_types_list.include?(data_type)
  end
end
