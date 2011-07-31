require 'spec_helper'

describe Host do
  before(:each) do
    @host = Factory.create(:host)
  end

  describe 'Attributes' do
    it 'has a Default Room (default_room)' do
      @host.should respond_to(:default_room)
      @host.should respond_to(:default_room=)
    end

    it 'has a Maximum Number of Visitors per Meeting (max_visitors_per_meeting)' do
      @host.should respond_to(:max_visitors_per_meeting)
      @host.should respond_to(:max_visitors_per_meeting=)
    end

    it 'has a Maximum Number of Visitors (max_visitors)' do
      @host.should respond_to(:max_visitors)
      @host.should respond_to(:max_visitors=)
    end
  end

  describe 'Named Scopes' do
    it "is sorted by its Person's Name" do
      @host.person.update_attributes(:first_name => 'Foo', :last_name => 'Bar')
      Factory.create(:host, :person => Factory.create(:person, :first_name => 'Ccc', :last_name => 'Ccc'))
      Factory.create(:host, :person => Factory.create(:person, :first_name => 'Jack', :last_name => 'Bbb'))
      Factory.create(:host, :person => Factory.create(:person, :first_name => 'Jill', :last_name => 'Bbb'))
      Host.all.map(&:person).map(&:name).should == ['Foo Bar', 'Jack Bbb', 'Jill Bbb', 'Ccc Ccc']
    end
  end

  describe 'Associations' do
    it 'belongs to an Event (event)' do
      @host.should belong_to(:event)
    end

    it 'belongs to a Person (person)' do
      @host.should belong_to(:person)
    end

    it 'has many HostRankings (rankings)' do
      @host.should have_many(:rankings)
    end

    it 'has many HostAvailabilities (availabilities)' do
      @host.should have_many(:availabilities)
    end

    it 'has many Meetings through HostAvailabilities' do
      @host.should have_many(:meetings).through(:availabilities)
    end
  end

  describe 'Nested Attributes' do
    describe 'Rankings (rankings)' do
      before(:each) do
        @visitor1 = Factory.create(:visitor)
        @visitor2 = Factory.create(:visitor)
      end

      it 'allows nested attributes for Rankings (rankings)' do
        @host.update_attributes(:rankings_attributes => [
            {:rank => 1, :rankable => @visitor1},
            {:rank => 2, :rankable => @visitor2}
        ])
        @host.rankings.map(&:rankable).map(&:id).should == [@visitor1.id, @visitor2.id]
      end

      it 'ignores entries with blank ranks' do
        @host.update_attributes(:rankings_attributes => [
            {:rank => 1, :rankable => @visitor1},
            {:rank => '', :rankable => @visitor2}
        ])
        @host.rankings.length.should == 1
      end

      it 'allows deletion' do
        @host.update_attributes(:rankings_attributes => [
            {:rank => 1, :rankable => @visitor1},
            {:rank => 2, :rankable => @visitor2}
        ])
        delete_id = @host.rankings.first.id
        @host.update_attributes(:rankings_attributes => [
            {:id => delete_id, :_destroy => true}
        ])
        @host.rankings.detect {|r| r.id == delete_id}.should be_marked_for_destruction
      end
    end

    describe 'Availabilities (availabilities)' do
      it 'allows nested attributes for Availabilities (availabilities)' do
        time_slot1 = Factory.create(:time_slot)
        time_slot2 = Factory.create(:time_slot)
        availability1 = @host.availabilities.find_by_time_slot_id(time_slot1.id)
        availability2 = @host.availabilities.find_by_time_slot_id(time_slot2.id)
        @host.update_attributes(:availabilities_attributes => [
            {:id => availability1.id, :available => true},
            {:id => availability2.id, :available => false}
        ])
        availability1.reload.should be_available
        availability2.reload.should_not be_available
      end
    end
  end

  context 'when building' do
    before(:each) do
      @host = Host.new
    end

    it 'has no Default Room (None)' do
      @host.default_room.should == 'None'
    end

    it 'has a default Max Visitors per Meeting of 4' do
      @host.max_visitors_per_meeting.should == 4
    end

    it 'has a default Max Visitors of 100' do
      @host.max_visitors.should == 100
    end
  end

  context 'when validating' do
    it 'is not valid without a Default Room' do
      @host.default_room = ''
      @host.should_not be_valid
    end

    it 'is not valid with an invalid Max Visitors Per Meeting' do
      ['', 0, -1, 5.5, 'foobar'].each do |invalid_preference|
        @host.max_visitors_per_meeting = invalid_preference
        @host.should_not be_valid
      end
    end

    it 'is not valid with an invalid Max Visitors' do
      ['', -1, 5.5, 'foobar'].each do |invalid_preference|
        @host.max_visitors = invalid_preference
        @host.should_not be_valid
      end
    end

    it 'is not valid with non-unique Ranking ranks' do
      rankings = [
          HostRanking.new(:rank => 1, :rankable => Factory.create(:visitor)),
          HostRanking.new(:rank => 1, :rankable => Factory.create(:visitor))
      ]
      @host.rankings = rankings
      @host.should_not be_valid
    end

    it 'is valid with non-unique Rankings that are marked for destruction' do
      rankings = [
          HostRanking.new(:rank => 1, :rankable => Factory.create(:visitor)),
          HostRanking.new(:rank => 1, :rankable => Factory.create(:visitor)),
          HostRanking.new(:rank => 1, :rankable => Factory.create(:visitor))
      ]
      rankings[0].mark_for_destruction
      rankings[1].mark_for_destruction
      @host.rankings = rankings
      @host.should be_valid
    end
  end

  context 'when destroying' do
    it 'destroys its Availabilities' do
      availabilities = Array.new(3) do
        availability = mock_model(Availability)
        availability.should_receive(:destroy)
        availability
      end
      @host.stub(:availabilities).and_return(availabilities)
      @host.destroy
    end

    it 'destroys its Rankings' do
      rankings = Array.new(3) do
        ranking = mock_model(HostRanking)
        ranking.should_receive(:destroy)
        ranking
      end
      @host.stub(:rankings).and_return(rankings)
      @host.destroy
    end

    it 'destroys the Visitor Rankings to which it belongs' do
      rankings = Array.new(3) do
        ranking = mock_model(VisitorRanking)
        ranking.should_receive(:destroy)
        ranking
      end
      @host.stub(:visitor_rankings).and_return(rankings)
      @host.destroy
    end
  end
end