class HostFieldType < FieldType

  default_scope order('sort_order')
  private

  def create_fields
    event.hosts.each {|r| r.fields.create(:field_type => self)}
  end
end
