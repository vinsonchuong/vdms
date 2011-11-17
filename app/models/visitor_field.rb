class VisitorField < Field
  belongs_to :role, :class_name => 'Visitor'
  belongs_to :field_type, :class_name => 'VisitorFieldType'
end
