class HostFieldType < FieldType
  has_many :fields, class_name: 'HostField', foreign_key: 'field_type_id', dependent: :destroy

  private

  def create_fields
    event.hosts.each {|r| r.fields.create(:field_type => self)}
  end
end
