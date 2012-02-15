class Field < ActiveRecord::Base
  after_initialize :include_feature_type_module

  serialize :data

  default_scope joins(:field_type).order('field_types.sort_order')

  private

  def include_feature_type_module
    unless field_type.nil? or field_type.data_type_module.nil?
      extend field_type.data_type_module::Field
    end
  end
end
