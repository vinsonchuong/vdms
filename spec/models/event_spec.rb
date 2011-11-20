require 'spec_helper'

describe Event do
  before(:each) do
    @event = Factory.create(:event)
  end

  describe 'Attributes' do
    it 'has a Name (name)' do
      @event.should respond_to(:name)
      @event.should respond_to(:name=)
    end

    it 'has a Meeting Length in minutes (meeting_length)' do
      @event.should respond_to(:meeting_length)
      @event.should respond_to(:meeting_length=)
    end

    it 'has a Meeting Gap in minutes (meeting_gap)' do
      @event.should respond_to(:meeting_gap)
      @event.should respond_to(:meeting_gap=)
    end

    it 'has a Prevent Facilitators From Making Changes flag (disable_facilitators)' do
      @event.should respond_to(:disable_facilitators)
      @event.should respond_to(:disable_facilitators=)
    end

    it 'has a Prevent Hosts From Making Changes flag (disable_hosts)' do
      @event.should respond_to(:disable_hosts)
      @event.should respond_to(:disable_hosts=)
    end

    it 'has a Max Meetings per Visitor (max_meetings_per_visitor)' do
      @event.should respond_to(:max_meetings_per_visitor)
      @event.should respond_to(:max_meetings_per_visitor=)
    end
  end

  describe 'Named Scopes' do
    it "is sorted by its Name" do
      @event.update_attributes(:name => 'Bbb')
      Factory.create(:event, :name => 'Ccc')
      Factory.create(:event, :name => 'Aaa')
      Factory.create(:event, :name => 'Ddd')
      Event.all.map(&:name).should == ['Aaa', 'Bbb', 'Ccc', 'Ddd']
    end
  end

  describe 'Associations' do
    it 'has many Time Slots (time_slots)' do
      @event.should have_many(:time_slots)
    end

    it 'has many HostFieldTypes (host_field_types)' do
      @event.should have_many(:host_field_types)
    end

    it 'has many VisitorFieldTypes (visitor_field_types)' do
      @event.should have_many(:visitor_field_types)
    end

    it 'has many Constraints (constraints)' do
      @event.should have_many(:constraints)
    end

    it 'has many Goals (goals)' do
      @event.should have_many(:goals)
    end

    it 'has many Roles (roles)' do
      @event.should have_many(:roles)
    end

    it 'has many Hosts (hosts)' do
      @event.should have_many(:hosts)
    end

    it 'has many Visitors (visitors)' do
      @event.should have_many(:visitors)
    end
  end

  describe 'Nested Attributes' do
    describe 'Meeting Times (meeting_times)' do
      context 'when getting' do
        it 'has a getter' do
          @event.should respond_to(:meeting_times)
        end

        it 'returns the list of Time Slots concatenated by Meeting Length and Gap' do
          time = Time.zone.parse('12PM')
          [
              [
                15.minutes,
                0,
                [
                  TimeSlot.new(:begin => time, :end => time + 15.minutes),
                  TimeSlot.new(:begin => time + 15.minutes, :end => time + 30.minutes),
                  TimeSlot.new(:begin => time + 30.minutes, :end => time + 45.minutes)
                ],
                [time..(time + 45.minutes)]
              ],
              [
                15.minutes,
                0,
                [
                  TimeSlot.new(:begin => time, :end => time + 15.minutes),
                  TimeSlot.new(:begin => time + 15.minutes, :end => time + 30.minutes),
                  TimeSlot.new(:begin => time + 60.minutes, :end => time + 75.minutes)
                ],
                [time..(time + 30.minutes), (time + 60.minutes)..(time + 75.minutes)]
              ],
              [
                15.minutes,
                5.minutes,
                [
                  TimeSlot.new(:begin => time, :end => time + 15.minutes),
                  TimeSlot.new(:begin => time + 20.minutes, :end => time + 35.minutes),
                  TimeSlot.new(:begin => time + 60.minutes, :end => time + 75.minutes)
                ],
                [time..(time + 35.minutes), (time + 60.minutes)..(time + 75.minutes)]
              ],
              [
                15.minutes,
                5.minutes,
                [
                  TimeSlot.new(:begin => time, :end => time + 15.minutes),
                  TimeSlot.new(:begin => time + 20.minutes, :end => time + 35.minutes),
                  TimeSlot.new(:begin => time + 41.minutes, :end => time + 56.minutes)
                ],
                [time..(time + 35.minutes), (time + 41.minutes)..(time + 56.minutes)]
              ]
          ].each do |meeting_length, meeting_gap, time_slots, result|
            @event.meeting_length = meeting_length
            @event.meeting_gap = meeting_gap
            @event.stub(:time_slots).and_return(time_slots)
            @event.meeting_times.should == result
          end
        end
      end

      context 'when setting' do
        it 'has a setter' do
          @event.should respond_to(:meeting_times_attributes=)
        end

        it 'partitions the times into Time Slots by Meeting Length and Gap' do
          time = Time.zone.parse('12PM')
          [
            [
              15.minutes,
              0,
              [
                  {:begin => time, :end => time + 30.minutes},
                  {:begin => time + 60.minutes, :end => time + 75.minutes},
              ],
              [],
              [],
              [
                time..(time + 15.minutes),
                (time + 15.minutes)..(time + 30.minutes),
                (time + 60.minutes)..(time + 75.minutes)
              ]
            ],
            [
              15.minutes,
              0,
              [
                  {:begin => time, :end => time + 30.minutes},
                  {:begin => time + 60.minutes, :end => time + 75.minutes},
              ],
              [
                {:begin => time, :end => time + 15.minutes}
              ],
              [
                {:begin => time + 75.minutes, :end => time + 90.minutes}
              ],
              [
                time..(time + 15.minutes),
                (time + 15.minutes)..(time + 30.minutes),
                (time + 60.minutes)..(time + 75.minutes)
              ]
            ],
            [
              15.minutes,
              5.minutes,
              [
                {:begin => time, :end => time + 60.minutes},
                {:begin => time + 120.minutes, :end => time + 135.minutes},
              ],
              [
                {:begin => time, :end => time + 15.minutes}
              ],
              [
                {:begin => time + 75.minutes, :end => time + 90.minutes}
              ],
              [
                time..(time + 15.minutes),
                (time + 20.minutes)..(time + 35.minutes),
                (time + 40.minutes)..(time + 55.minutes),
                (time + 120.minutes)..(time + 135.minutes)
              ]
            ],
            [
              15.minutes,
              5.minutes,
              [
                {:begin => time, :end => time + 60.minutes},
                {:begin => time + 120.minutes, :end => time + 135.minutes},
              ],
              [
                {:begin => time, :end => time + 15.minutes}
              ],
              [
                {:begin => time + 15.minutes, :end => time + 30.minutes},
                {:begin => time + 75.minutes, :end => time + 90.minutes}
              ],
              [
                time..(time + 15.minutes),
                (time + 20.minutes)..(time + 35.minutes),
                (time + 40.minutes)..(time + 55.minutes),
                (time + 120.minutes)..(time + 135.minutes)
              ]
            ],
            [
              15.minutes,
              5.minutes,
              [
                {:begin => time, :end => time + 60.minutes},
                {:begin => time + 120.minutes, :end => time + 135.minutes, :_destroy => true},
              ],
              [
                {:begin => time, :end => time + 15.minutes}
              ],
              [
                {:begin => time + 15.minutes, :end => time + 30.minutes},
                {:begin => time + 75.minutes, :end => time + 90.minutes}
              ],
              [
                time..(time + 15.minutes),
                (time + 20.minutes)..(time + 35.minutes),
                (time + 40.minutes)..(time + 55.minutes)
              ]
            ],
            [
              15.minutes,
              5.minutes,
              [
                {:begin => time, :end => time + 60.minutes},
                {:begin => nil, :end => nil},
              ],
              [
                {:begin => time, :end => time + 15.minutes}
              ],
              [
                {:begin => time + 15.minutes, :end => time + 30.minutes},
                {:begin => time + 75.minutes, :end => time + 90.minutes}
              ],
              [
                time..(time + 15.minutes),
                (time + 20.minutes)..(time + 35.minutes),
                (time + 40.minutes)..(time + 55.minutes)
              ]
            ]
          ].each do |meeting_length, meeting_gap, meeting_times, time_slots_to_keep, time_slots_to_remove, results|
            @event.meeting_length = meeting_length
            @event.meeting_gap = meeting_gap
            @event.time_slots.delete_all
            time_slots_to_keep.map! {|t| @event.time_slots.create(t)}
            time_slots_to_remove.map! {|t| @event.time_slots.create(t)}
            @event.meeting_times_attributes = meeting_times
            @event.save!
            @event.time_slots.reload.map {|s| (s.begin)..(s.end)}.should == results
            (@event.time_slots & time_slots_to_keep).should == time_slots_to_keep
            (@event.time_slots & time_slots_to_remove).should be_empty
          end
        end
      end
    end
  end

  context 'when building' do
    it 'by default has a Prevent Facilitators From Making Changes flag of false' do
      @event.disable_facilitators.should be_false
    end

    it 'by default has a Prevent Hosts From Making Changes flag of false' do
      @event.disable_hosts.should be_false
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @event.should be_valid
    end

    it 'is not valid without a Name' do
      @event.name = ''
      @event.should_not be_valid
    end

    it 'is not valid without a Meeting Length' do
      @event.meeting_length = ''
      @event.should_not be_valid
    end

    it 'is not valid with an invalid Meeting Length' do
      [-1, 0, 1.5, 'foo'].each do |invalid_length|
        @event.meeting_length = invalid_length
        @event.should_not be_valid
      end
    end

    it 'is not valid without a Meeting Gap' do
      @event.meeting_gap = ''
      @event.should_not be_valid
    end

    it 'is not valid with an invalid Meeting Gap' do
      [-1, 1.5, 'foo'].each do |invalid_gap|
        @event.meeting_gap = invalid_gap
        @event.should_not be_valid
      end
    end

    it 'is not valid without a Prevent Facilitators From Making Changes flag' do
      @event.disable_facilitators = nil
      @event.should_not be_valid
    end

    it 'is not valid without a Prevent Hosts From Making Changes flag' do
      @event.disable_hosts = nil
      @event.should_not be_valid
    end

    it 'is not valid without a Maximum Number of Meetings per Visitor' do
      pending
      @event.max_meetings_per_visitor = ''
      @event.should_not be_valid
    end

    it 'is not valid with an invalid Maximum Number of Meetings per Visitor' do
      pending
      [-1, 1.5, 'foo'].each do |invalid_meetings|
        @event.max_meetings_per_visitor = invalid_meetings
        @event.should_not be_valid
      end
    end
  end

  context 'when destroying' do
    it 'destroys its Time Slots' do
      time_slots = Array.new(3) do
        time_slot = mock_model(TimeSlot)
        time_slot.should_receive(:destroy)
      time_slot
      end
      @event.stub(:time_slots).and_return(time_slots)
      @event.destroy
    end

    it 'destroys its HostFieldTypes' do
      host_field_types = Array.new(3) do
        host_field_types = mock_model(HostFieldType)
        host_field_types.should_receive(:destroy)
        host_field_types
      end
      @event.stub(:host_field_types).and_return(host_field_types)
      @event.destroy
    end

    it 'destroys its VisitorFieldTypes' do
      visitor_field_types = Array.new(3) do
        visitor_field_types = mock_model(VisitorFieldType)
        visitor_field_types.should_receive(:destroy)
        visitor_field_types
      end
      @event.stub(:visitor_field_types).and_return(visitor_field_types)
      @event.destroy
    end

    it 'destroys its Goals' do
      goals = Array.new(3) do
        goal = mock_model(Goal)
        goal.should_receive(:destroy)
        goal
      end
      @event.stub(:goals).and_return(goals)
      @event.destroy
    end

    it 'destroys its Constraints' do
      constraints = Array.new(3) do
        constraint = mock_model(Constraint)
        constraint.should_receive(:destroy)
        constraint
      end
      @event.stub(:constraints).and_return(constraints)
      @event.destroy
    end

    it 'destroys its Hosts' do
      hosts = Array.new(3) do
        host = mock_model(Host)
        host.should_receive(:destroy)
        host
      end
      @event.stub(:hosts).and_return(hosts)
      @event.destroy
    end

    it 'destroys its Visitors' do
      visitors = Array.new(3) do
        visitor = mock_model(Visitor)
        visitor.should_receive(:destroy)
        visitor
      end
      @event.stub(:visitors).and_return(visitors)
      @event.destroy
    end
  end
end
