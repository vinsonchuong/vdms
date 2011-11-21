require 'spec_helper'

describe HostField do
  before(:each) do
    @field = Factory.create(:visitor_field)
  end

  describe 'Attributes' do
    it 'has Data (data)' do
      @field.should respond_to(:data)
      @field.should respond_to(:data=)
    end
  end

  describe 'Named Scopes' do
    it 'is sorted by VisitorFieldType'
  end

  describe 'Associations' do
    it 'belongs to a Host (role)' do
      @field.should belong_to(:role)
      @field.role.should be_a_kind_of Visitor
    end

    it 'belongs to a VisitorFieldType (field_type)' do
      @field.should belong_to(:field_type)
      @field.field_type.should be_a_kind_of VisitorFieldType
    end
  end

  context 'when initializing' do
    before(:each) do
      @field = VisitorField.find(@field.id)
    end

    it 'includes the corresponding DataType module' do
      @field.singleton_class.included_modules.should include(DataTypes::Text::Field)
    end
  end
end
