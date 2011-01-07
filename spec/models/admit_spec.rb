require 'spec_helper'

describe Admit do
  before(:each) do
    @admit = Factory.build(:admit)
  end

  describe 'Attributes' do
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

    it 'has an Attending flag (attending)' do
      @admit.should respond_to(:attending)
      @admit.should respond_to(:attending=)
    end

    it 'has a list of Available Times (available_times)' do
      @admit.should respond_to(:available_times)
      @admit.should respond_to(:available_times=)
    end

    it 'has an attribute name to accessor map' do
      Admit::ATTRIBUTES['CalNet ID'].should == :calnet_id
      Admit::ATTRIBUTES['First Name'].should == :first_name
      Admit::ATTRIBUTES['Last Name'].should == :last_name
      Admit::ATTRIBUTES['Email'].should == :email
      Admit::ATTRIBUTES['Phone'].should == :phone
      Admit::ATTRIBUTES['Area 1'].should == :area1
      Admit::ATTRIBUTES['Area 2'].should == :area2
      Admit::ATTRIBUTES['Attending'].should == :attending
      Admit::ATTRIBUTES['Available Times'].should == :available_times
    end

    it 'has an accessor to type map' do
      Admit::ATTRIBUTE_TYPES[:calnet_id].should == :string
      Admit::ATTRIBUTE_TYPES[:first_name].should == :string
      Admit::ATTRIBUTE_TYPES[:last_name].should == :string
      Admit::ATTRIBUTE_TYPES[:email].should == :string
      Admit::ATTRIBUTE_TYPES[:phone].should == :string
      Admit::ATTRIBUTE_TYPES[:area1].should == :string
      Admit::ATTRIBUTE_TYPES[:area2].should == :string
      Admit::ATTRIBUTE_TYPES[:attending].should == :boolean
      Admit::ATTRIBUTE_TYPES[:available_times].should == :range_set
    end
  end

  describe 'Associations' do
    it 'belongs to a Peer Advisor (peer_advisor)' do
      @admit.should belong_to(:peer_advisor)
    end

    it 'has many Faculty Rankings (faculty_rankings)' do
      @admit.should have_many(:faculty_rankings)
    end

    it 'has and belongs to many Meetings (meetings)' do
      @admit.should have_and_belong_to_many(:meetings)
    end
  end

  context 'when building' do
    before(:each) do
      @admit = Admit.new
    end

    it 'is by default not Attending' do
      @admit.attending.should == false
    end

    it 'by default has no Available Times' do
      @admit.available_times.to_a.should be_empty
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

    it 'is not valid without an Email' do
      @admit.email = ''
      @admit.should_not be_valid
    end

    it 'is not valid with an invalid Email' do
      ['foobar', 'foo@bar', 'foo.com'].each do |invalid_email|
        @admit.email = invalid_email
        @admit.should_not be_valid
      end
    end

    it 'is valid with a valid phone' do
      ['1234567890', '(123) 456-7890', '123.456.7890', '123-456-7890'].each do |valid_phone|
        @admit.phone = valid_phone
        @admit.should be_valid
      end
    end

    it 'is not valid without a Phone' do
      @admit.phone = ''
      @admit.should_not  be_valid
    end

    it 'is not valid with an invalid Phone' do
      ['12345678', 'foobarbaz', '12345678900'].each do |invalid_phone|
        @admit.phone = invalid_phone
        @admit.should_not be_valid
      end
    end

    it 'is not valid without an Area 1' do
      @admit.area1 = ''
      @admit.should_not be_valid
    end

    it 'is not valid without an Area 2' do
      @admit.area2 = ''
      @admit.should_not be_valid
    end

    it 'is not valid without an Attending flag' do
      @admit.attending = nil
      @admit.should_not be_valid
    end

    it 'is not valid with invalid Available Times'

    it 'is not valid with an invalid Peer Advisor' do
      @admit.peer_advisor = PeerAdvisor.new
      @admit.should_not be_valid
    end
  end

  context 'after validating' do
    it 'parses and formats Phone' do
      ['1234567890', '123-456-7890', '123.456.7890'].each do |phone|
        @admit.phone = phone
        @admit.valid?
        @admit.phone.should == '(123) 456-7890'
      end
    end
  end

  context 'when destroying' do
    before(:each) do
      @admit.save
    end

    it 'destroys its Faculty Rankings' do
      faculty_rankings = Array.new(3) do
        faculty_ranking = Factory.create(:faculty_ranking, :admit => @admit)
        faculty_ranking.should_receive(:destroy)
        faculty_ranking
      end
      @admit.stub(:faculty_rankings).and_return(faculty_rankings)
      @admit.destroy
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

    context 'with valid attributes' do
      before(:each) do
        csv_text = <<-EOF.gsub(/^ {10}/, '')
          CalNet ID,First Name,Last Name,Email,Phone,Area 1,Area 2,Attending
          ID0,First0,Last0,email0@email.com,1234567890,Area 10,Area 20,false
          ID1,First1,Last1,email1@email.com,1234567891,Area 11,Area 21,false
          ID2,First2,Last2,email2@email.com,1234567892,Area 12,Area 22,false
        EOF
        @csv = FasterCSV.parse(csv_text, :headers => :first_row)
      end

      it 'creates an Admit with the attributes in each row' do
        Admit.import_csv(@csv.to_s)
        @admits.each_with_index do |admit, i|
          admit.should_not be_a_new_record
          admit.calnet_id.should == "ID#{i}"
          admit.first_name.should == "First#{i}"
          admit.last_name.should == "Last#{i}"
          admit.email.should == "email#{i}@email.com"
          admit.phone.should == "(123) 456-789#{i}"
          admit.area1.should == "Area 1#{i}"
          admit.area2.should == "Area 2#{i}"
          admit.attending.should == false
        end
      end
  
      it 'creates an Admit with the partial attributes in each row' do
        @csv.delete('Attending')
        Admit.import_csv(@csv.to_s)
        @admits.each_with_index do |admit, i|
          admit.should_not be_a_new_record
          admit.calnet_id.should == "ID#{i}"
          admit.first_name.should == "First#{i}"
          admit.last_name.should == "Last#{i}"
          admit.email.should == "email#{i}@email.com"
          admit.phone.should == "(123) 456-789#{i}"
          admit.area1.should == "Area 1#{i}"
          admit.area2.should == "Area 2#{i}"
        end
      end
  
      it 'ignores extraneous attributes' do
        csv_text = <<-EOF.gsub(/^ {10}/, '')
          CalNet ID,Baz,First Name,Last Name,Email,Phone,Area 1,Area 2,Attending,Foo,Bar
          ID0,Baz0,First0,Last0,email0@email.com,1234567890,Area 10,Area 20,false,Foo0,Bar0
          ID1,Baz1,First1,Last1,email1@email.com,1234567891,Area 11,Area 21,false,Foo1,Bar1
          ID2,Baz2,First2,Last2,email2@email.com,1234567892,Area 12,Area 22,false,Foo2,Bar2
        EOF
        Admit.import_csv(csv_text)
        @admits.each_with_index do |admit, i|
          admit.should_not be_a_new_record
          admit.calnet_id.should == "ID#{i}"
          admit.first_name.should == "First#{i}"
          admit.last_name.should == "Last#{i}"
          admit.email.should == "email#{i}@email.com"
          admit.phone.should == "(123) 456-789#{i}"
          admit.area1.should == "Area 1#{i}"
          admit.area2.should == "Area 2#{i}"
          admit.attending.should == false
        end
      end
  
      it 'returns the collection of created Admits' do
        Admit.import_csv(@csv.to_s).should == @admits
      end
    end

    context 'with invalid attributes' do
      before(:each) do
        csv_text = <<-EOF.gsub(/^ {10}/, '')
          CalNet ID,First Name,Last Name,Email,Phone,Area 1,Area 2,Attending
          ID0,,Last0,email0@email.com,1234567890,Area 10,Area 20,false
          ID1,First1,,email1@email.com,1234567891,Area 11,Area 21,false
          ID2,First2,Last2,email2@email.com,1234567892,Area 12,Area 22,false
        EOF
        @csv = FasterCSV.parse(csv_text, :headers => :first_row)
      end

      it 'saves no Admits to the database' do
        @admits.all? {|a| a.new_record?}.should be_true
      end

      it 'returns the collection of unsaved Admits' do
        Admit.import_csv(@csv.to_s).should == @admits
      end
    end
  end
end
