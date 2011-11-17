class HostField < Field
  belongs_to :role, :class_name => 'Host'
  belongs_to :field_type, :class_name => 'HostFieldType'
end
