require 'spec_helper'

describe Visitor do
  before(:each) do
    @visitor = Factory.create(:visitor)
    @event = @visitor.event
    Event.stub(:find).and_return(@event)
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
      @visitor.person.update_attributes(:last_name => 'Aaa', :first_name => 'Aaa')
      Factory.create(:visitor, :person => Factory.create(:person, :last_name => 'Aaa', :first_name => 'Bbb'))
      Factory.create(:visitor, :person => Factory.create(:person, :last_name => 'Ccc', :first_name => 'Ccc'))
      Factory.create(:visitor, :person => Factory.create(:person, :last_name => 'Ddd', :first_name => 'Ddd'))
      Visitor.all.map(&:person).map {|p| p.first_name + ' ' + p.last_name}.should == [
        'Aaa Aaa', 'Bbb Aaa', 'Ccc Ccc', 'Ddd Ddd'
      ]
    end
  end

  describe 'Associations' do
    it 'belongs to an Event (event)' do
      @visitor.should belong_to(:event)
    end

    it 'belongs to a Person (person)' do
      @visitor.should belong_to(:person)
    end

    it 'has many VisitorFields (fields)' do
      @visitor.should have_many(:fields)
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

      describe 'Fields' do
        before(:each) do
          @field_type1 = Factory.create(:visitor_field_type)
          @field_type2 = Factory.create(:visitor_field_type)
        end

        it 'allows nested attributes for Fields' do
          @visitor.update_attribute(:fields_attributes, [
              {:field_type => @field_type1, :data => 'Data1'},
              {:field_type => @field_type1, :data => 'Data2'}
          ])
          @visitor.fields.map(&:data).should == ['Data1', 'Data2']
        end

        it 'does not allow the creation of new Fields'
      end

      it 'allows nested attributes for Person (person)' do
        @visitor.update_attributes(:person_attributes => {
          :id => @person.id,
          :first_name => 'New',
          :last_name => 'Name'
        })
        @person.reload.name.should == 'New Name'
      end

      it 'only allows updates' do
        @visitor.update_attributes(:person_attributes => Factory.build(:person).attributes)
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
        @visitor.rankings.none? {|r| r.id == delete_id}.should be_true
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

    it 'has a Field for each VisitorFieldType' do
      # this code is in the Event model
      # find a way to avoid having to hit database
      field_types = Array.new(3) {Factory.create(:visitor_field_type, :event => @event)}
      new_visitor = @event.visitors.build
      new_visitor.fields.map(&:field_type).should == field_types
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @visitor.should be_valid
    end

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
    it 'destroys its Fields' do
      3.times do
        field = Factory.create(:visitor_field, :role => @visitor)
        field.should_receive(:destroy)
        @visitor.fields << field
      end
      @visitor.destroy
    end

    it 'destroys its Availabilities' do
      3.times do
        availability = Factory.create(:visitor_availability, :schedulable => @visitor)
        availability.should_receive(:destroy)
        @visitor.availabilities << availability
      end
      @visitor.destroy
    end

    it 'destroys its Rankings' do
      3.times do
        ranking = Factory.create(:visitor_ranking, :ranker => @visitor)
        ranking.should_receive(:destroy)
        @visitor.rankings << ranking
      end
      @visitor.destroy
    end

    it 'destroys the Host Rankings to which it belongs' do
      3.times do
        ranking = Factory.create(:host_ranking, :rankable => @visitor)
        ranking.should_receive(:destroy)
        @visitor.host_rankings << ranking
      end
      @visitor.destroy
    end
  end
end
