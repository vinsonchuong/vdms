class VisitorFieldType < FieldType
  has_many :fields, class_name: 'VisitorField', foreign_key: 'field_type_id', dependent: :destroy

  private

  def create_fields
    event.visitors.each {|r| r.fields.create(:field_type => self)}
  end
end
