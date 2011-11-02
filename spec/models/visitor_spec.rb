require 'spec_helper'

describe Visitor do
  before(:each) do
    @visitor = Factory.create(:visitor)
  end

  describe 'Attributes' do
    it 'has a Verified flag (verified)' do
      @visitor.should respond_to(:verified)
      @visitor.should respond_to(:verified?)
      @visitor.should respond_to(:verified=)
    end
  end

  describe 'Named Scopes' do
    it "is sorted by its Person's Name" do
      @visitor.person.update_attributes(:name => 'Aaa')
      Factory.create(:visitor, :person => Factory.create(:person, :name => 'Ccc'))
      Factory.create(:visitor, :person => Factory.create(:person, :name => 'Bbb'))
      Factory.create(:visitor, :person => Factory.create(:person, :name => 'Ddd'))
      Visitor.all.map(&:person).map(&:name).should == ['Aaa', 'Bbb', 'Ccc', 'Ddd']
    end
  end

  describe 'Associations' do
    it 'belongs to an Event (event)' do
      @visitor.should belong_to(:event)
    end

    it 'belongs to a Person (person)' do
      @visitor.should belong_to(:person)
    end

    it 'has many VisitorRankings (rankings)' do
      @visitor.should have_many(:rankings)
    end

    it 'has many VisitorAvailabilities (availabilities)' do
      @visitor.should have_many(:availabilities)
    end

    it 'has many Meetings through VisitorAvailabilities' do
      @visitor.should have_many(:meetings).through(:availabilities)
    end
  end

  describe 'Nested Attributes' do
    describe 'Person (person)' do
      before(:each) do
        @person = @visitor.person
      end

      it 'allows nested attributes for Person (person)' do
        @visitor.update_attributes(:person_attributes => {
            :id => @person.id,
            :name => 'New Name'
        })
        @person.reload.name.should == 'New Name'
      end

      it 'only allows updates' do
        @visitor.update_attributes(:person_attributes => Factory.attributes_for(:person))
        @visitor.reload.person.should == @person
      end
    end

    describe 'Rankings (rankings)' do
      before(:each) do
        @host1 = Factory.create(:host)
        @host2 = Factory.create(:host)
      end

      it 'allows nested attributes for Rankings (rankings)' do
        @visitor.update_attributes(:rankings_attributes => [
            {:rank => 1, :rankable => @host1},
            {:rank => 2, :rankable => @host2}
        ])
        @visitor.rankings.map(&:rankable).map(&:id).should == [@host1.id, @host2.id]
      end

      it 'ignores entries with blank ranks' do
        @visitor.update_attributes(:rankings_attributes => [
            {:rank => 1, :rankable => @host1},
            {:rank => '', :rankable => @host2}
        ])
        @visitor.rankings.length.should == 1
      end

      it 'allows deletion' do
        @visitor.update_attributes(:rankings_attributes => [
            {:rank => 1, :rankable => @host1},
            {:rank => 2, :rankable => @host2}
        ])
        delete_id = @visitor.rankings.first.id
        @visitor.update_attributes(:rankings_attributes => [
            {:id => delete_id, :_destroy => true}
        ])
        @visitor.rankings.detect {|r| r.id == delete_id}.should be_marked_for_destruction
      end
    end

    describe 'Availabilities (availabilities)' do
      it 'allows nested attributes for Availabilities (availabilities)' do
        time_slot1 = Factory.create(:time_slot, :event => @visitor.event)
        time_slot2 = Factory.create(:time_slot, :event => @visitor.event)
        availability1 = @visitor.availabilities.find_by_time_slot_id(time_slot1.id)
        availability2 = @visitor.availabilities.find_by_time_slot_id(time_slot2.id)
        @visitor.update_attributes(:availabilities_attributes => [
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
      @visitor = Visitor.new
    end

    it 'is not Verified' do
      @visitor.should_not be_verified
    end

    it 'has no Default Room (None)' do
      @visitor.default_room.should == 'None'
    end

    it 'has a default Max Visitors per Meeting of 4' do
      @visitor.max_visitors_per_meeting.should == 4
    end

    it 'has a default Max Visitors of 100' do
      @visitor.max_visitors.should == 100
    end
  end

  context 'when validating' do
    it 'is not valid with non-unique Ranking ranks' do
      rankings = [
          VisitorRanking.new(:rank => 1, :rankable => Factory.create(:host)),
          VisitorRanking.new(:rank => 1, :rankable => Factory.create(:host))
      ]
      @visitor.rankings = rankings
      @visitor.should_not be_valid
    end

    it 'is valid with non-unique Rankings that are marked for destruction' do
      rankings = [
          VisitorRanking.new(:rank => 1, :rankable => Factory.create(:host)),
          VisitorRanking.new(:rank => 1, :rankable => Factory.create(:host)),
          VisitorRanking.new(:rank => 1, :rankable => Factory.create(:host))
      ]
      rankings[0].mark_for_destruction
      rankings[1].mark_for_destruction
      @visitor.rankings = rankings
      @visitor.should be_valid
    end
  end

  context 'when destroying' do
    it 'destroys its Availabilities' do
      availabilities = Array.new(3) do
        availability = mock_model(Availability)
        availability.should_receive(:destroy)
        availability
      end
      @visitor.stub(:availabilities).and_return(availabilities)
      @visitor.destroy
    end

    it 'destroys its Rankings' do
      rankings = Array.new(3) do
        ranking = mock_model(VisitorRanking)
        ranking.should_receive(:destroy)
        ranking
      end
      @visitor.stub(:rankings).and_return(rankings)
      @visitor.destroy
    end

    it 'destroys the Visitor Rankings to which it belongs' do
      rankings = Array.new(3) do
        ranking = mock_model(HostRanking)
        ranking.should_receive(:destroy)
        ranking
      end
      @visitor.stub(:host_rankings).and_return(rankings)
      @visitor.destroy
    end
  end
end
