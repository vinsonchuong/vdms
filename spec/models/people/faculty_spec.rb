require 'spec_helper'

describe Faculty do
  before(:each) do
    @faculty = Factory.create(:faculty)
  end

  describe 'Attributes' do
    it 'has an LDAP ID (ldap_id)' do
      @faculty.should respond_to(:ldap_id)
      @faculty.should respond_to(:ldap_id=)
    end

    it 'has a First Name (first_name)' do
      @faculty.should respond_to(:first_name)
      @faculty.should respond_to(:first_name=)
    end

    it 'has a Last Name (last_name)' do
      @faculty.should respond_to(:last_name)
      @faculty.should respond_to(:last_name=)
    end

    it 'has an Email (email)' do
      @faculty.should respond_to(:email)
      @faculty.should respond_to(:email=)
    end

    it 'has an Area (area)' do
      @faculty.should respond_to(:area)
      @faculty.should respond_to(:area=)
    end

    it 'has a Division (division)' do
      @faculty.should respond_to(:division)
      @faculty.should respond_to(:division=)
    end

    it 'has an attribute name to accessor map' do
      Faculty::ATTRIBUTES['LDAP ID'].should == :ldap_id
      Faculty::ATTRIBUTES['First Name'].should == :first_name
      Faculty::ATTRIBUTES['Last Name'].should == :last_name
      Faculty::ATTRIBUTES['Email'].should == :email
      Faculty::ATTRIBUTES['Area 1'].should == :area1
      Faculty::ATTRIBUTES['Area 2'].should == :area2
      Faculty::ATTRIBUTES['Area 3'].should == :area3
      Faculty::ATTRIBUTES['Division'].should == :division
    end

    it 'has an accessor to type map' do
      Faculty::ATTRIBUTE_TYPES[:ldap_id].should == :string
      Faculty::ATTRIBUTE_TYPES[:first_name].should == :string
      Faculty::ATTRIBUTE_TYPES[:last_name].should == :string
      Faculty::ATTRIBUTE_TYPES[:email].should == :string
      Faculty::ATTRIBUTE_TYPES[:area1].should == :string
      Faculty::ATTRIBUTE_TYPES[:area2].should == :string
      Faculty::ATTRIBUTE_TYPES[:area3].should == :string
      Faculty::ATTRIBUTE_TYPES[:division].should == :string
    end
  end

  describe 'Virtual Attributes' do
    it 'has a Full Name (full_name)' do
      @faculty.full_name.should == "#{@faculty.first_name} #{@faculty.last_name}"
    end
  end

  describe 'Named Scopes' do
    it 'has a list of Faculty sorted by last and first name (by_name)' do
      @faculty.update_attributes(:first_name => 'Foo', :last_name => 'Bar')
      Factory.create(:faculty, :first_name => 'Ccc', :last_name => 'Ccc')
      Factory.create(:faculty, :first_name => 'Jack', :last_name => 'Bbb')
      Factory.create(:faculty, :first_name => 'Jill', :last_name => 'Bbb')
      Faculty.by_name.map {|a| "#{a.first_name} #{a.last_name}"}.should == ['Foo Bar', 'Jack Bbb', 'Jill Bbb', 'Ccc Ccc']
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @faculty.should be_valid
    end

    it 'is not valid without a First Name' do
      @faculty.first_name = ''
      @faculty.should_not be_valid
    end

    it 'is not valid without a Last Name' do
      @faculty.last_name = ''
      @faculty.should_not be_valid
    end

    it 'is not valid without an Email' do
      @faculty.email = ''
      @faculty.should_not be_valid
    end

    it 'is not valid with an invalid Email' do
      ['foobar', 'foo@bar', 'foo.com'].each do |invalid_email|
        @faculty.email = invalid_email
        @faculty.should_not be_valid
      end
    end

    it 'is not valid with an invalid Division' do
      stub_divisions('D1' => 'Division 1', 'D2' => 'Division 2')
      ['', 'Division 3', 123].each do |invalid_division|
        @faculty.division = invalid_division
        @faculty.should_not be_valid
      end
    end

    it 'is not valid with an invalid Area' do
      stub_areas('A1' => 'Area 1', 'A2' => 'Area 2')
      ['Area 3', 123].each do |invalid_area|
        @faculty.area = invalid_area
        @faculty.should_not be_valid
      end
    end

    it 'is valid with a valid division' do
      Settings.instance.divisions.map(&:last).each do |division|
        @faculty.division = division
        @faculty.should be_valid
      end
    end

    it 'is not valid with an invalid division' do
      ['', 1, 'invalid_division'].each do |invalid_division|
        @faculty.division = invalid_division
        @faculty.should_not be_valid
      end
    end

    it 'is not valid without a Division' do
      @faculty.division = ''
      @faculty.should_not be_valid
    end
  end

  context 'after validating' do
    it 'maps Area to its canonical form' do
      stub_areas('A1' => 'Area 1', 'A2' => 'Area 2')
      ['A1', 'Area 1'].each do |area|
        @faculty.area = area
        @faculty.valid?
        @faculty.area.should == 'A1'
      end

      @faculty.area = nil
      @faculty.valid?
      @faculty.area.should == nil
    end

    it 'maps Division to its canonical form' do
      stub_divisions('D1' => 'Division 1', 'D2' => 'Division 2')
      ['D1', 'Division 1'].each do |division|
        @faculty.division = division
        @faculty.valid?
        @faculty.division.should == 'D1'
      end

      @faculty.division = nil
      @faculty.valid?
      @faculty.division.should == nil
    end
  end

  context 'when importing a CSV' do
    before(:each) do
      @faculties = Array.new(3) {Faculty.new}
      new_faculties = @faculties.dup
      Faculty.stub(:new) do |*args|
        faculty = new_faculties.shift
        faculty.attributes = args[0]
        faculty
      end
    end

    it 'builds a collection of Faculty with the attributes in each row' do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        First Name,Last Name,Email,Division,Area 1,Area 2, Area 3
        First0,Last0,email0@email.com,Division0,Area0,,
        First1,Last1,email1@email.com,Division1,Area1,,
        First2,Last2,email2@email.com,Division2,Area2,,
      EOF
      Faculty.new_from_csv(csv_text).should == @faculties
      @faculties.each_with_index do |faculty, i|
        faculty.first_name.should == "First#{i}"
        faculty.last_name.should == "Last#{i}"
        faculty.email.should == "email#{i}@email.com"
        faculty.division.should == "Division#{i}"
        faculty.area1.should == "Area#{i}"
      end
    end

    it 'ignores extraneous attributes' do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        Baz,First Name,Last Name,Email,Division,Area 1,Foo,Bar
        Baz0,First0,Last0,email0@email.com,Division0,Area0,Foo0,Bar0
        Baz1,First1,Last1,email1@email.com,Division1,Area1,Foo1,Bar1
        Baz2,First2,Last2,email2@email.com,Division2,Area2,Foo2,Bar2
      EOF
      Faculty.new_from_csv(csv_text).should == @faculties
      @faculties.each_with_index do |faculty, i|
        faculty.first_name.should == "First#{i}"
        faculty.last_name.should == "Last#{i}"
        faculty.email.should == "email#{i}@email.com"
        faculty.division.should == "Division#{i}"
        faculty.area1.should == "Area#{i}"
      end
    end
  end
end
