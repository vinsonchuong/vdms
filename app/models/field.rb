class Field < ActiveRecord::Base
  after_initialize :include_feature_type_module

  serialize :data

  private

  def include_feature_type_module
    unless field_type.nil? or field_type.data_type_module.nil?
      extend field_type.data_type_module::Field
    end
  end
end
