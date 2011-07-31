require 'spec_helper'

describe Admit do
  before(:each) do
    @admit = Factory.create(:admit)
  end

  describe 'Attributes' do
    it 'has an LDAP ID (ldap_id)' do
      @admit.should respond_to(:ldap_id)
      @admit.should respond_to(:ldap_id=)
    end

    it 'has a First Name (first_name)' do
      @admit.should respond_to(:first_name)
      @admit.should respond_to(:first_name=)
    end

    it 'has a Last Name (last_name)' do
      @admit.should respond_to(:last_name)
      @admit.should respond_to(:last_name=)
    end

    it 'has an Email (email)' do
      @admit.should respond_to(:email)
      @admit.should respond_to(:email=)
    end

    it 'has a Phone (phone)' do
      @admit.should respond_to(:phone)
      @admit.should respond_to(:phone=)
    end

    it 'has an Area 1 (area1)' do
      @admit.should respond_to(:area1)
      @admit.should respond_to(:area1=)
    end

    it 'has an Area 2 (area2)' do
      @admit.should respond_to(:area2)
      @admit.should respond_to(:area2=)
    end
    
    it 'has an attribute name to accessor map' do
      Admit::ATTRIBUTES['LDAP ID'].should == :ldap_id
      Admit::ATTRIBUTES['First Name'].should == :first_name
      Admit::ATTRIBUTES['Last Name'].should == :last_name
      Admit::ATTRIBUTES['Email'].should == :email
      Admit::ATTRIBUTES['Phone'].should == :phone
      Admit::ATTRIBUTES['Area 1'].should == :area1
      Admit::ATTRIBUTES['Area 2'].should == :area2
    end

    it 'has an accessor to type map' do
      Admit::ATTRIBUTE_TYPES[:ldap_id].should == :string
      Admit::ATTRIBUTE_TYPES[:first_name].should == :string
      Admit::ATTRIBUTE_TYPES[:last_name].should == :string
      Admit::ATTRIBUTE_TYPES[:email].should == :string
      Admit::ATTRIBUTE_TYPES[:phone].should == :string
      Admit::ATTRIBUTE_TYPES[:area1].should == :string
      Admit::ATTRIBUTE_TYPES[:area2].should == :string
    end
  end

  describe 'Virtual Attributes' do
    it 'has a Full Name (full_name)' do
      @admit.full_name.should == "#{@admit.first_name} #{@admit.last_name}"
    end
  end

  describe 'Named Scopes' do
    it 'has a list of Admits sorted by last and first name (by_name)' do
      @admit.update_attributes(:first_name => 'Foo', :last_name => 'Bar')
      Factory.create(:admit, :first_name => 'Ccc', :last_name => 'Ccc')
      Factory.create(:admit, :first_name => 'Jack', :last_name => 'Bbb')
      Factory.create(:admit, :first_name => 'Jill', :last_name => 'Bbb')
      Admit.by_name.map(&:full_name).should == ['Foo Bar', 'Jack Bbb', 'Jill Bbb', 'Ccc Ccc']
    end

    it 'has a list of Admits with the given Areas, sorted by last and first name (with_areas)' do
      #Refactor Area inclusion validation to allow stubbing
      #stub_areas('a1' => 'Area 1', 'a2' => 'Area 2', 'a3' => 'Area 3')
      @admit.update_attributes(:first_name => 'Foo', :last_name => 'Bar', :area1 => 'ai', :area2 => '')
      Factory.create(:admit, :first_name => 'Ccc', :last_name => 'Ccc', :area1 => 'ai', :area2 => '')
      Factory.create(:admit, :first_name => 'Jack', :last_name => 'Bbb', :area1 => 'bio', :area2 => '')
      Factory.create(:admit, :first_name => 'Jill', :last_name => 'Bbb', :area1 => 'cir', :area2 => '')
      Admit.with_areas('ai').map(&:full_name).should == ['Foo Bar', 'Ccc Ccc']
      Admit.with_areas('ai', 'bio').map(&:full_name).should == ['Foo Bar', 'Jack Bbb', 'Ccc Ccc']
      Admit.with_areas('ai', 'bio', 'cir').map(&:full_name).should == ['Foo Bar', 'Jack Bbb', 'Jill Bbb', 'Ccc Ccc']
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @admit.should be_valid
    end

    it 'is not valid without a First Name' do
      @admit.first_name = ''
      @admit.should_not be_valid
    end

    it 'is not valid without a Last Name' do
      @admit.last_name = ''
      @admit.should_not be_valid
    end

    it 'is valid with a valid Area 1' do
      stub_areas('A1' => 'Area 1', 'A2' => 'Area 2')
      ['A1', 'Area 1', 'A2', 'Area 2'].each do |area|
        @admit.area1 = area
        @admit.should_not be_valid
      end
    end

    it 'is valid without an Area 1' do
      @admit.area1 = ''
      @admit.should be_valid
    end

    it 'is not valid with an invalid Area 1' do
      stub_areas('A1' => 'Area 1', 'A2' => 'Area 2')
      ['Area 3', 123].each do |invalid_area|
        @admit.area1 = invalid_area
        @admit.should_not be_valid
      end
    end

    it 'is valid with a valid Area 2' do
      stub_areas('A1' => 'Area 1', 'A2' => 'Area 2')
      ['A1', 'Area 1', 'A2', 'Area 2'].each do |area|
        @admit.area2 = area
        @admit.should_not be_valid
      end
    end

    it 'is valid without an Area 1' do
      @admit.area2 = ''
      @admit.should be_valid
    end

    it 'is not valid with an invalid Area 2' do
      stub_areas('A1' => 'Area 1', 'A2' => 'Area 2')
      ['Area 3', 123].each do |invalid_area|
        @admit.area2 = invalid_area
        @admit.should_not be_valid
      end
    end
  end

  context 'after validating' do
    it 'maps Areas to their canonical forms' do
      stub_areas('A1' => 'Area 1', 'A2' => 'Area 2')
      [
        ['Area 1', 'Area 2'],
        ['A1', 'A2'],
        ['Area 1', 'A2']
      ].each do |area1, area2|
        @admit.area1 = area1
        @admit.area2 = area2
        @admit.valid?
        @admit.area1.should == 'A1'
        @admit.area2.should == 'A2'
      end

      @admit.area1 = nil
      @admit.valid?
      @admit.area1.should == nil
    end
  end

  context 'when importing a CSV' do
    before(:each) do
      @admits = Array.new(3) {Admit.new}
      new_admits = @admits.dup
      Admit.stub(:new) do |*args|
        admit = new_admits.shift
        admit.attributes = args[0]
        admit
      end
    end

    it 'builds a collection of Admits with the attributes in each row' do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        First Name,Last Name,Email,Phone,Area 1,Area 2
        First0,Last0,email0@email.com,1234567890,Area 10,Area 20
        First1,Last1,email1@email.com,1234567891,Area 11,Area 21
        First2,Last2,email2@email.com,1234567892,Area 12,Area 22
      EOF
      Admit.new_from_csv(csv_text).should == @admits
      @admits.each_with_index do |admit, i|
        admit.first_name.should == "First#{i}"
        admit.last_name.should == "Last#{i}"
        admit.email.should == "email#{i}@email.com"
        admit.phone.should == "123456789#{i}"
        admit.area1.should == "Area 1#{i}"
        admit.area2.should == "Area 2#{i}"
      end
    end

    it 'also allows Faculty Rankings to be specified' do
      pending
      faculty1 = Factory.create(:faculty, :first_name => 'First1', :last_name => 'Last1')
      faculty2 = Factory.create(:faculty, :first_name => 'First2', :last_name => 'Last2')
      faculty3 = Factory.create(:faculty, :first_name => 'First3', :last_name => 'Last3')
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        First Name,Last Name,Email,Phone,Area 1,Area 2,Faculty 1,Faculty 2,Faculty 3
        First0,Last0,email0@email.com,1234567890,Area 10,Area 20,First1 Last1,First2 Last2,First3 Last3
        First1,Last1,email1@email.com,1234567891,Area 11,Area 21,First2 Last2,First3 Last3,First1 Last1
        First2,Last2,email2@email.com,1234567892,Area 12,Area 22,First3 Last3,First1 Last1,First2 Last2
      EOF
      Admit.new_from_csv(csv_text).should == @admits
      @admits.each_with_index do |admit, i|
        admit.first_name.should == "First#{i}"
        admit.last_name.should == "Last#{i}"
        admit.email.should == "email#{i}@email.com"
        admit.phone.should == "123456789#{i}"
        admit.area1.should == "Area 1#{i}"
        admit.area2.should == "Area 2#{i}"
        admit.rankings.detect {|r| r.rank == 1}.rankable.full_name.should == "First#{(i%3)+1} Last#{(i%3)+1}"
        admit.rankings.detect {|r| r.rank == 2}.rankable.full_name.should == "First#{((i+1)%3)+1} Last#{((i+1)%3)+1}"
        admit.rankings.detect {|r| r.rank == 3}.rankable.full_name.should == "First#{((i+2)%3)+1} Last#{((i+2)%3)+1}"
      end
    end

    it 'ignores extraneous attributes' do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        Baz,First Name,Last Name,Email,Phone,Area 1,Area 2,Foo,Bar
        Baz0,First0,Last0,email0@email.com,1234567890,Area 10,Area 20,Foo0,Bar0
        Baz1,First1,Last1,email1@email.com,1234567891,Area 11,Area 21,Foo1,Bar1
        Baz2,First2,Last2,email2@email.com,1234567892,Area 12,Area 22,Foo2,Bar2
      EOF
      Admit.new_from_csv(csv_text).should == @admits
      @admits.each_with_index do |admit, i|
        admit.first_name.should == "First#{i}"
        admit.last_name.should == "Last#{i}"
        admit.email.should == "email#{i}@email.com"
        admit.phone.should == "123456789#{i}"
        admit.area1.should == "Area 1#{i}"
        admit.area2.should == "Area 2#{i}"
      end
    end
  end
end
