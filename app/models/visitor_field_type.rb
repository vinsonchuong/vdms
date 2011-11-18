class VisitorFieldType < FieldType

  private

  def create_fields
    event.visitors.each {|r| r.fields.create(:field_type => self)}
  end
end
