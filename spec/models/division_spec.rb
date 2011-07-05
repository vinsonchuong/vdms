require 'spec_helper'

describe Division do
  before(:each) do
    settings = Settings.instance
    @division = settings.divisions.create(:name => STATIC_SETTINGS['divisions'].keys.first)
  end

  describe 'Attributes' do
    it 'has a Name (name)' do
      @division.should respond_to(:name)
      @division.should respond_to(:name=)
    end
  end

  describe 'Virtual Attributes' do
    it 'has a Long Name (long_name)' do
      @division.long_name.should == STATIC_SETTINGS['divisions'][@division.name]
    end
  end

  describe 'Associations' do
    it 'belongs to Settings (settings)' do
      @division.should belong_to(:settings)
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @division.should be_valid
    end

    it 'is not valid without a Name' do
      @division.name = ''
      @division.should_not be_valid
    end

    it 'is not valid if it is not owned by a Settings' do
      @division.settings = nil
      @division.should_not be_valid
    end

    it 'is not valid if it is not owned by a valid Settings' do
      @division.settings.destroy
      @division.should_not be_valid
    end
  end
end
