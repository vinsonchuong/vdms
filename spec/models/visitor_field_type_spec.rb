require 'spec_helper'

describe VisitorFieldType do
  before(:each) do
    @field_type = Factory.create(:visitor_field_type)
    @event = @field_type.event
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
      expect {@field_type.update_attribute(:data_type, 'single_select')}.should raise_error
    end

    it 'has an Options hash (options)' do
      pending
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

    it 'has many VisitorFields (fields)' do
      @field_type.should have_many(:fields)
    end
  end

  context 'when building' do
    before(:each) do
      @field_type = VisitorFieldType.new
    end

    it 'has an empty Options hash' do
      @field_type.options.should == {}
    end
  end

  context 'when initializing' do
    before(:each) do
      @field_type = VisitorFieldType.find(@field_type.id)
    end

    it 'includes the corresponding DataType module' do
      @field_type.singleton_class.included_modules.should include(DataTypes::Text::FieldType)
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
      @field_type = Factory.build(:host_field_type, :data_type => '')
      @field_type.should_not be_valid
    end

    it 'is not valid with an invalid Data Type' do
      ['INVALIDTYPE', ''].each do |invalid_type|
        @field_type = Factory.build(:host_field_type, :data_type => invalid_type)
        @field_type.should_not be_valid
      end
    end
  end

  context 'after creating' do
    it 'creates a corresponding VisitorField for each Visitor' do
      pending
      new_field_type = Factory.build(:visitor_field_type, :event => @event)
      3.times do
        visitor = Factory.create(:visitor, :event => @event)
        visitor.stub_chain(:fields, :build)
        visitor.fields.should_receive(:create)
        @event.visitors << visitor
      end
      new_field_type.save
    end
  end

  context 'when destroying' do
    it 'destroys its associated VisitorFields' do
      3.times do
        field = Factory.create(:visitor_field)
        field.should_receive(:destroy)
        @field_type.fields << field
      end
      @field_type.destroy
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
