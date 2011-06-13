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

  describe 'Associations' do
    describe 'Time Slots' do
      it 'has many Time Slots (time_slots)' do
        @admit.should have_many(:time_slots)
      end

      it 'has many Time Slots sorted by Start Time' do
        @admit.time_slots.create(:begin => Time.zone.parse('1/4/2011'), :end => Time.zone.parse('1/5/2011'))
        @admit.time_slots.create(:begin => Time.zone.parse('1/3/2011'), :end => Time.zone.parse('1/4/2011'))
        @admit.time_slots.create(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        @admit.time_slots.reload.map {|t| t.attributes['begin']}.should == [
          Time.zone.parse('1/3/2011'),
          Time.zone.parse('1/4/2011'),
          Time.zone.parse('1/6/2011'),
        ]
      end
    end

    describe 'Faculty Rankings' do
      it 'has many Faculty Rankings (faculty_rankings)' do
        @admit.should have_many(:faculty_rankings)
      end

      it 'has many Faculty Rankings sorted by rank' do
        @admit.faculty_rankings.create(:rank => 2, :faculty => Factory.create(:faculty))
        @admit.faculty_rankings.create(:rank => 1, :faculty => Factory.create(:faculty))
        @admit.faculty_rankings.create(:rank => 3, :faculty => Factory.create(:faculty))
        @admit.faculty_rankings.reload.map {|r| r.attributes['rank']}.should == [1, 2, 3]
      end
    end

    it 'has and belongs to many Meetings (meetings)' do
      pending
      @admit.should have_and_belong_to_many(:meetings)
    end
  end

  describe 'Nested Attributes' do
    describe 'Time Slots (time_slots)' do
      it 'allows nested attributes for Time Slots (time_slots)' do
        attributes = {:time_slots_attributes => [
          {:begin => Time.zone.parse('1/1/2011'), :end => Time.zone.parse('1/2/2011')},
          {:begin => Time.zone.parse('1/3/2011'), :end => Time.zone.parse('1/4/2011')}
        ]}
        @admit.attributes = attributes
        @admit.time_slots.each_with_index do |time, i|
          time.begin.should == attributes[:time_slots_attributes][i][:begin]
          time.end.should == attributes[:time_slots_attributes][i][:end]
        end
      end
  
      it 'ignores completely blank entries' do
        attributes = {:time_slots_attributes => [
          {:begin => Time.zone.parse('1/1/2011'), :end => Time.zone.parse('1/2/2011')},
          {:begin => '', :end => ''}
        ]}
        @admit.attributes = attributes
        @admit.time_slots.length.should == 1
      end
    end

    describe 'Faculty Rankings (faculty_rankings)' do
      before(:each) do
        @faculty1 = Factory.create(:faculty)
        @faculty2 = Factory.create(:faculty)
      end
      
      it 'allows nested attributes for Faculty Rankings (faculty_rankings)' do
        attributes = {:faculty_rankings_attributes => [
          {:rank => 1, :faculty => @faculty1},
          {:rank => 2, :faculty => @faculty2}
        ]}
        @admit.attributes = attributes
        @admit.faculty_rankings.map {|r| r.faculty.id}.should == [@faculty1.id, @faculty2.id]
      end

      it 'ignores entries with blank ranks' do
        attributes = {:faculty_rankings_attributes => [
          {:rank => 1, :faculty => @faculty1},
          {:rank => '', :faculty => @faculty2}
        ]}
        @admit.attributes = attributes
        @admit.faculty_rankings.length.should == 1
      end

      it 'allows deletion' do
        attributes = {:faculty_rankings_attributes => [
          {:rank => 1, :faculty => @faculty1},
          {:rank => 2, :faculty => @faculty2}
        ]}
        @admit.attributes = attributes
        @admit.save

        delete_id = @admit.faculty_rankings.first.id
        new_attributes = {:faculty_rankings_attributes => [
          {:id => delete_id, :_destroy => true}
        ]}
        @admit.attributes = new_attributes
        @admit.faculty_rankings.detect {|r| r.id == delete_id}.should be_marked_for_destruction
      end
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

    it 'is valid with valid non-overlapping Time Slots' do
      [
        [
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/8/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/6/2011')),
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |times|
        @admit.time_slots = times
        @admit.should be_valid
      end
    end

    it 'is not valid with invalid Time Slots' do
      @admit.time_slots.build
      @admit.should_not be_valid
    end

    it 'is not valid with overlapping Time Slots' do
      [
        [
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/8/2011'))
        ],
        [
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/9/2011'))
        ],
        [
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011')),
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/7/2011'))
        ]
      ].each do |times|
        @admit.time_slots = times
        @admit.should_not be_valid
      end
    end

    it 'is valid with overlapping Time Slots that are marked for destruction' do
      time1 = VisitorTimeSlot.new(:begin => Time.zone.parse('1/5/2011'), :end => Time.zone.parse('1/8/2011'))
      time2 = VisitorTimeSlot.new(:begin => Time.zone.parse('1/6/2011'), :end => Time.zone.parse('1/8/2011'))
      time3 = VisitorTimeSlot.new(:begin => Time.zone.parse('1/7/2011'), :end => Time.zone.parse('1/9/2011'))
      @admit.time_slots = [time1, time2, time3]
      time1.mark_for_destruction
      time2.mark_for_destruction
      @admit.should be_valid
    end

    it 'is not valid with non-unique Faculty Ranking ranks' do
      faculty_rankings = [
        FacultyRanking.new(:rank => 1, :faculty => Factory.create(:faculty)),
        FacultyRanking.new(:rank => 1, :faculty => Factory.create(:faculty))
      ]
      @admit.faculty_rankings = faculty_rankings
      @admit.should_not be_valid
    end

    it 'is valid with non-unique Faculty Rankings that are marked for destruction' do
      faculty_rankings = [
        FacultyRanking.new(:rank => 1, :faculty => Factory.create(:faculty)),
        FacultyRanking.new(:rank => 1, :faculty => Factory.create(:faculty)),
        FacultyRanking.new(:rank => 1, :faculty => Factory.create(:faculty))
      ]
      faculty_rankings[0].mark_for_destruction
      faculty_rankings[1].mark_for_destruction
      @admit.faculty_rankings = faculty_rankings
      @admit.should be_valid
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

  context 'when destroying' do
    it 'destroys its Time Slots' do
      time_slots = Array.new(3) do |i|
        time_slot = VisitorTimeSlot.create(
          :begin => Time.zone.parse("1:00PM 1/#{i + 1}/2011"),
          :end => Time.zone.parse("5:00PM 1/#{i + 1}/2011")
        )
        time_slot.should_receive(:destroy)
        time_slot
      end
      @admit.stub(:time_slots).and_return(time_slots)
      @admit.destroy
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

    it 'destroys its Admit Rankings' do
      admit_rankings = Array.new(3) do
        faculty_ranking = Factory.create(:admit_ranking, :admit => @admit)
        faculty_ranking.should_receive(:destroy)
        faculty_ranking
      end
      @admit.stub(:admit_rankings).and_return(admit_rankings)
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
        admit.faculty_rankings.detect {|r| r.rank == 1}.faculty.full_name.should == "First#{(i%3)+1} Last#{(i%3)+1}"
        admit.faculty_rankings.detect {|r| r.rank == 2}.faculty.full_name.should == "First#{((i+1)%3)+1} Last#{((i+1)%3)+1}"
        admit.faculty_rankings.detect {|r| r.rank == 3}.faculty.full_name.should == "First#{((i+2)%3)+1} Last#{((i+2)%3)+1}"
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

  context 'when building a list of time slots' do
    before(:each) do
      @meeting_times = [
        VisitorTimeSlot.new(:begin => Time.zone.parse('1/1/2011 8AM'), :end => Time.zone.parse('1/1/2011 9AM')),
        VisitorTimeSlot.new(:begin => Time.zone.parse('1/1/2011 10AM'), :end => Time.zone.parse('1/1/2011 10:15AM')),
        VisitorTimeSlot.new(:begin => Time.zone.parse('1/1/2011 10:30AM'), :end => Time.zone.parse('1/1/2011 11AM'))
      ]
      @meeting_length = 15 * 60
      @meeting_gap = 5 * 60
    end

    context 'when no available meeting slots have been specified' do
      it 'partitions the given times and produces an TimeSlot for each resulting slot' do
        @admit.build_time_slots(@meeting_times, @meeting_length, @meeting_gap)
        @admit.time_slots.map {|t| {:begin => t.begin, :end => t.end}}.should == [
          {:begin => Time.zone.parse('1/1/2011 8AM'), :end => Time.zone.parse('1/1/2011 8:15AM')},
          {:begin => Time.zone.parse('1/1/2011 8:20AM'), :end => Time.zone.parse('1/1/2011 8:35AM')},
          {:begin => Time.zone.parse('1/1/2011 8:40AM'), :end => Time.zone.parse('1/1/2011 8:55AM')},
          {:begin => Time.zone.parse('1/1/2011 10AM'), :end => Time.zone.parse('1/1/2011 10:15AM')},
          {:begin => Time.zone.parse('1/1/2011 10:30AM'), :end => Time.zone.parse('1/1/2011 10:45AM')}
        ]
      end
    end

    context 'when some available meeting times have been specified' do
      it 'partitions the given times - already specified times and produces an TimeSlot for each resulting slot' do
        specified_times = [
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/1/2011 8AM'), :end => Time.zone.parse('1/1/2011 8:15AM')),
          VisitorTimeSlot.new(:begin => Time.zone.parse('1/1/2011 10AM'), :end => Time.zone.parse('1/1/2011 10:15AM'))
        ]
        @admit.time_slots += specified_times
        @admit.save
        @admit.build_time_slots(@meeting_times, @meeting_length, @meeting_gap)
        @admit.time_slots.map {|t| {:begin => t.begin, :end => t.end}}.should == [
          {:begin => Time.zone.parse('1/1/2011 8AM'), :end => Time.zone.parse('1/1/2011 8:15AM')},
          {:begin => Time.zone.parse('1/1/2011 8:20AM'), :end => Time.zone.parse('1/1/2011 8:35AM')},
          {:begin => Time.zone.parse('1/1/2011 8:40AM'), :end => Time.zone.parse('1/1/2011 8:55AM')},
          {:begin => Time.zone.parse('1/1/2011 10AM'), :end => Time.zone.parse('1/1/2011 10:15AM')},
          {:begin => Time.zone.parse('1/1/2011 10:30AM'), :end => Time.zone.parse('1/1/2011 10:45AM')}
        ]
        [0, 3].each {|i| @admit.time_slots[i].should_not be_a_new_record}
        [1, 2, 4].each {|i| @admit.time_slots[i].should be_a_new_record}
      end
    end
  end
end
