require 'spec_helper'

describe Constraint do
  before(:each) do
    @feature = Factory.create(:constraint)
  end

  describe 'Attributes' do
    it 'has a Name (name)' do
      @feature.should respond_to(:name)
      @feature.should respond_to(:name=)
    end

    it 'has a Weight (weight)' do
      @feature.should respond_to(:weight)
      @feature.should respond_to(:weight=)
    end

    it 'has a Feature Type (feature_type)' do
      @feature.should respond_to(:feature_type)
      @feature.should respond_to(:feature_type=)
    end

    it 'has an Options hash (options)' do
      pending
      @feature.should respond_to(:options)
      @feature.should respond_to(:options=)
      expect {@feature.update_attribute(:options, [])}.should raise_exception ActiveRecord::SerializationTypeMismatch
      expect {@feature.update_attribute(:options, {})}.should_not raise_error
    end
  end

  describe 'Associations' do
    it 'belongs to an Event (event)' do
      @feature.should belong_to(:event)
    end

    it 'belongs to a HostFieldType (host_field_type)' do
      @feature.should belong_to(:host_field_type)
    end

    it 'belongs to a VisitorFieldType (visitor_field_type)' do
      @feature.should belong_to(:visitor_field_type)
    end
  end

  context 'when building' do
    before(:each) do
      @feature = Constraint.new
    end

    it 'has an empty Options hash' do
      @feature.options.should == {}
    end
  end

  context 'when initializing' do
    before(:each) do
      @feature = Constraint.find(@feature.id)
    end

    it 'includes the corresponding Feature module' do
      pending
      #@feature.metaclass.included_modules.should include(DataTypes::Text::FieldType)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @feature.should be_valid
    end

    it 'is not valid without a Name' do
      @feature.name = ''
      @feature.should_not be_valid
    end

    it 'is not valid without a Feature Type' do
      @feature.feature_type = ''
      @feature.should_not be_valid
    end

    it 'is not valid with an invalid Feature Type' do
      pending
    end
  end
end
