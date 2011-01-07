require 'spec_helper'

describe Staff do
  before(:each) do
    @staff = Factory.build(:staff)
  end

  describe 'Attributes' do
    it 'has a CalNet ID (calnet_id)' do
      @staff.should respond_to(:calnet_id)
      @staff.should respond_to(:calnet_id=)
    end

    it 'has a First Name (first_name)' do
      @staff.should respond_to(:first_name)
      @staff.should respond_to(:first_name=)
    end

    it 'has a Last Name (last_name)' do
      @staff.should respond_to(:last_name)
      @staff.should respond_to(:last_name=)
    end

    it 'has an Email (email)' do
      @staff.should respond_to(:email)
      @staff.should respond_to(:email=)
    end

    it 'has an attribute name to accessor map' do
      Staff::ATTRIBUTES['CalNet ID'].should == :calnet_id
      Staff::ATTRIBUTES['First Name'].should == :first_name
      Staff::ATTRIBUTES['Last Name'].should == :last_name
      Staff::ATTRIBUTES['Email'].should == :email
    end

    it 'has an accessor to type map' do
      Staff::ATTRIBUTE_TYPES[:calnet_id].should == :string
      Staff::ATTRIBUTE_TYPES[:first_name].should == :string
      Staff::ATTRIBUTE_TYPES[:last_name].should == :string
      Staff::ATTRIBUTE_TYPES[:email].should == :string
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @staff.should be_valid
    end

    it 'is not valid without a Calnet ID' do
      @staff.calnet_id = ''
      @staff.should_not be_valid
    end

    it 'is not valid without a First Name' do
      @staff.first_name = ''
      @staff.should_not be_valid
    end

    it 'is not valid without a Last Name' do
      @staff.last_name = ''
      @staff.should_not be_valid
    end

    it 'is not valid without an Email' do
      @staff.email = ''
      @staff.should_not be_valid
    end

    it 'is not valid with an invalid Email' do
      ['foobar', 'foo@bar', 'foo.com'].each do |invalid_email|
        @staff.email = invalid_email
        @staff.should_not be_valid
      end
    end
  end

  context 'when importing a CSV' do
    before(:each) do
      @staffs = Array.new(3) {Staff.new}
      new_staffs = @staffs.dup
      Staff.stub(:new) do |*args|
        staff = new_staffs.shift
        staff.attributes = args[0]
        staff
      end
    end

    context 'with valid attributes' do
      before(:each) do
        csv_text = <<-EOF.gsub(/^ {10}/, '')
          CalNet ID,First Name,Last Name,Email
          ID0,First0,Last0,email0@email.com
          ID1,First1,Last1,email1@email.com
          ID2,First2,Last2,email2@email.com
        EOF
        @csv = FasterCSV.parse(csv_text, :headers => :first_row)
      end

      it 'creates a Staff with the attributes in each row' do
        Staff.import_csv(@csv.to_s)
        @staffs.each_with_index do |staff, i|
          staff.should_not be_a_new_record
          staff.calnet_id.should == "ID#{i}"
          staff.first_name.should == "First#{i}"
          staff.last_name.should == "Last#{i}"
          staff.email.should == "email#{i}@email.com"
        end
      end
  
      it 'ignores extraneous attributes' do
        csv_text = <<-EOF.gsub(/^ {10}/, '')
          CalNet ID,Baz,First Name,Last Name,Email,Foo,Bar
          ID0,Baz0,First0,Last0,email0@email.com,Foo0,Bar0
          ID1,Baz1,First1,Last1,email1@email.com,Foo1,Bar1
          ID2,Baz2,First2,Last2,email2@email.com,Foo2,Bar2
        EOF
        Staff.import_csv(csv_text)
        @staffs.each_with_index do |staff, i|
          staff.should_not be_a_new_record
          staff.calnet_id.should == "ID#{i}"
          staff.first_name.should == "First#{i}"
          staff.last_name.should == "Last#{i}"
          staff.email.should == "email#{i}@email.com"
        end
      end
  
      it 'returns the collection of created Staffs' do
        Staff.import_csv(@csv.to_s).should == @staffs
      end      
    end

    context 'with invalid attributes' do
      before(:each) do
        csv_text = <<-EOF.gsub(/^ {10}/, '')
          CalNet ID,First Name,Last Name,Email
          ID0,,Last0,email0@email.com
          ID1,First1,,email1@email.com
          ID2,First2,Last2,email2@email.com
        EOF
        @csv = FasterCSV.parse(csv_text, :headers => :first_row)
      end

      it 'saves no Staff to the database' do
        @staffs.all? {|s| s.new_record?}.should be_true
      end

      it 'returns the collection of unsaved Staffs' do
        Staff.import_csv(@csv.to_s).should == @staffs
      end
    end
  end
end
