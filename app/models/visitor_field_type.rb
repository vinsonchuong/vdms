class VisitorFieldType < FieldType

  default_scope order('sort_order')
  private

  def create_fields
    event.visitors.each {|r| r.fields.create(:field_type => self)}
  end
end
