require 'spec_helper'

describe HostField do
  before(:each) do
    @field = Factory.create(:host_field)
  end

  describe 'Attributes' do
    it 'has Data (data)' do
      @field.should respond_to(:data)
      @field.should respond_to(:data=)
    end
  end

  describe 'Named Scopes' do
    it 'is sorted by HostFieldType'
  end

  describe 'Associations' do
    it 'belongs to a Host (role)' do
      @field.should belong_to(:role)
      @field.role.should be_a_kind_of Host
    end

    it 'belongs to a HostFieldType (field_type)' do
      @field.should belong_to(:field_type)
      @field.field_type.should be_a_kind_of HostFieldType
    end
  end

  context 'when initializing' do
    before(:each) do
      @field = HostField.find(@field.id)
    end

    it 'includes the corresponding DataType module' do
      @field.singleton_class.included_modules.should include(DataTypes::Text::Field)
    end
  end
end
