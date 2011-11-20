class Feature < ActiveRecord::Base
  def after_initialize
    self.options ||= {}
    puts self.feature_type_module
    self.extend self.feature_type_module unless self.feature_type_module.nil?
  end

  belongs_to :event
  belongs_to :host_field_type
  belongs_to :visitor_field_type

  attr_readonly :feature_type
  serialize :options, Hash

  validates_presence_of :name
  validates_presence_of :feature_type
  validate :existence_of_feature_type

  def self.feature_list_for(host_field_type, visitor_field_type)
    h = host_field_type.data_type
    v = visitor_field_type.data_type

    if h == 'multiple_select' and v == 'multiple_select'
      [
        ['set/intersect', 'They should intersect.'],
        ['set/not_intersect', 'They should not intersect.'],
        ['equality/equals', 'They should be the same.'],
        ['equality/not_equals', 'They should not be the same.']
      ]
    elsif h == 'multiple_select' or v == 'multiple_select'
      [
        ['set/intersect', 'They should intersect.'],
        ['set/not_intersect', 'They should not intersect.'],
      ]
    else
      [
        ['equality/equals', 'They should be the same.'],
        ['equality/not_equals', 'They should not be the same.']
      ]
    end
  end

  def feature_type_module
    feature_type.blank? ?
      nil :
      "feature_types/#{feature_type.split('/')[0]}".camelize.constantize
  rescue NameError
    nil
  end

  private

  def existence_of_feature_type
  end
end
