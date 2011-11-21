require 'spec_helper'

describe HostFieldType do
  before(:each) do
    @field_type = Factory.create(:host_field_type)
    @event = @field_type.event
    Event.stub(:find).and_return(@event)
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

    it 'has many HostFields (fields)' do
      @field_type.should have_many(:fields)
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

  context 'when initializing' do
    before(:each) do
      @field_type = HostFieldType.find(@field_type.id)
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

  context 'after creating' do
    it 'creates a corresponding HostField for each Host' do
      new_field_type = Factory.build(:host_field_type, :event => @event)
      hosts = Array.new(3) do
        host = @event.hosts.build
        host.fields.should_receive(:create)
        host
      end
      @event.stub(:hosts).and_return(hosts)
      new_field_type.save
    end
  end

  context 'when destroying' do
    it 'destroys its associated HostFields' do
      fields = Array.new(3) do
        field = mock_model(HostField)
        field.should_receive(:destroy)
        field
      end
      @field_type.stub(:fields).and_return(fields)
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
