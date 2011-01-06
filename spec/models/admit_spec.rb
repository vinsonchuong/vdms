require 'spec_helper'

describe Admit do
  describe 'Attributes' do
    before(:each) do
      @admit = Admit.new
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
  end

  describe 'Associations' do
    before(:each) do
      @admit = Admit.new
    end

    it 'belongs to a peer advisor (peer_advisor)' do
      @admit.should belong_to(:peer_advisor)
    end

    it 'has many faculty rankings (faculty_rankings)' do
      @admit.should have_many(:faculty_rankings)
    end

    it 'has and belongs to many meetings (meetings)' do
      @admit.should have_and_belong_to_many(:meetings)
    end
  end

  context 'when importing a CSV' do
    before(:each) do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        CalNet ID,First Name,Last Name,Email,Phone,Area 1,Area 2,Attending
        ID0,First0,Last0,email0@email.com,1234567890,Area 10,Area 20,false
        ID1,First1,Last1,email1@email.com,1234567891,Area 11,Area 21,false
        ID2,First2,Last2,email2@email.com,1234567892,Area 12,Area 22,false
      EOF
      @csv = FasterCSV.parse(csv_text, :headers => :first_row)

      # Stub out the database and replace it with @admit array
      @admits = []
      new_admits = Array.new(3) {Admit.new}
      new_admits.each do |admit|
        admit.stub(:save) {@admits << admit}
      end
      Admit.stub(:new) do |*args|
        admit = new_admits.shift
        admit.attributes = args[0]
        admit
      end
    end

    it 'creates an Admit per row' do
      Admit.import_csv(@csv.to_s)
      @admits.count.should == 3
    end

    it 'creates a Admit with the attributes in each row' do
      Admit.import_csv(@csv.to_s)
      @admits.each_with_index do |admit, i|
        admit.calnet_id.should == "ID#{i}"
        admit.first_name.should == "First#{i}"
        admit.last_name.should == "Last#{i}"
        admit.email.should == "email#{i}@email.com"
        admit.phone.should == "123456789#{i}"
        admit.area1.should == "Area 1#{i}"
        admit.area2.should == "Area 2#{i}"
        admit.attending.should == false
      end
    end

    it 'creates a Admit with the partial attributes in each row' do
      @csv.delete('First Name')
      @csv.delete('Last Name')
      Admit.import_csv(@csv.to_s)
      @admits.each_with_index do |admit, i|
        admit.calnet_id.should == "ID#{i}"
        admit.email.should == "email#{i}@email.com"
        admit.phone.should == "123456789#{i}"
        admit.area1.should == "Area 1#{i}"
        admit.area2.should == "Area 2#{i}"
        admit.attending.should == false
      end
    end

    it 'ignores extraneous attributes' do
      csv_text = <<-EOF.gsub(/^ {8}/, '')
        CalNet ID,Baz,First Name,Last Name,Email,Foo,Bar
        ID0,Baz0,First0,Last0,email0@email.com,Foo0,Bar0
        ID1,Baz1,First1,Last1,email1@email.com,Foo1,Bar1
        ID2,Baz2,First2,Last2,email2@email.com,Foo2,Bar2
      EOF
      Admit.import_csv(csv_text)
      @admits.count.should == 3
      @admits.each_with_index do |admit, i|
        admit.calnet_id.should == "ID#{i}"
        admit.first_name.should == "First#{i}"
        admit.last_name.should == "Last#{i}"
        admit.email.should == "email#{i}@email.com"
      end
    end
  end
end
