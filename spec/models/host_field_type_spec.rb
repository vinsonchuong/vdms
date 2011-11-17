require 'spec_helper'

describe HostFieldType do
  before(:each) do
    @field_type = Factory.create(:host_field_type)
  end

  describe 'Attributes' do
    it 'has a Name (name)' do
      @field_type.should respond_to(:name)
      @field_type.should respond_to(:name=)
    end

    it 'has a Description (description)' do
      @field_type.should respond_to(:description)
      @field_type.should respond_to(:description=)
    end

    it 'has a readonly Data Type (data_type)' do
      @field_type.should respond_to(:data_type)
      @field_type.should respond_to(:data_type=)
      old_field_type = @field_type.data_type
      @field_type.update_attribute(:data_type, 'single_select').should be_true
      @field_type.reload.data_type.should == old_field_type
    end

    it 'has an Options hash (options)' do
      @field_type.should respond_to(:options)
      @field_type.should respond_to(:options=)
      expect {@field_type.update_attribute(:options, [])}.should raise_exception ActiveRecord::SerializationTypeMismatch
      expect {@field_type.update_attribute(:options, {})}.should_not raise_error
    end
  end

  describe 'Associations' do
    it 'belongs to an Event (event)' do
      @field_type.should belong_to(:event)
    end
  end

  context 'when building' do
    before(:each) do
      @field_type = HostFieldType.new
    end

    it 'has an empty Options hash' do
      @field_type.options.should == {}
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @field_type.should be_valid
    end

    it 'is not valid without a Name' do
      @field_type.name = ''
      @field_type.should_not be_valid
    end

    it 'is not valid without a Data Type' do
      @field_type.data_type = ''
      @field_type.should_not be_valid
    end

    it 'is not valid with an invalid Data Type' do
      ['INVALIDTYPE', ''].each do |invalid_type|
        @field_type.data_type = invalid_type
        @field_type.should_not be_valid
      end
    end
  end

  context 'when getting the module corresponding to the Data Type' do
    it 'returns the Module if the Data Type is valid' do
      @field_type.data_type = 'text'
      @field_type.data_type_module.should == DataTypes::Text
    end

    it 'returns nil if the Data Type is not valid' do
      ['INVALID', ''].each do |invalid_type|
        @field_type.data_type = invalid_type
        @field_type.data_type_module.should == nil
      end
    end
  end
end
