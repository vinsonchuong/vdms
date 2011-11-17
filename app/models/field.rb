class Field < ActiveRecord::Base
  def after_initialize
    unless self.field_type.nil? or self.field_type.data_type_module.nil?
      self.extend self.field_type.data_type_module
    end
  end
end
