require 'spec_helper'

describe Settings do
  before(:each) do
    @settings = Settings.instance
    @settings.save
  end

  describe 'Attributes' do
    it 'has an Unsatisfied Admit Threshold (unsatisfied_admit_threshold)' do
      @settings.should respond_to(:unsatisfied_admit_threshold)
      @settings.should respond_to(:unsatisfied_admit_threshold=)
    end

    it 'has a Disable Faculty From Making Changes flag (disable_faculty)' do
      @settings.should respond_to(:disable_faculty)
      @settings.should respond_to(:disable_faculty=)
    end

    it 'has a Disable Peer Advisors From Making Changes flag (disable_peer_advisors)' do
      @settings.should respond_to(:disable_peer_advisors)
      @settings.should respond_to(:disable_peer_advisors=)
    end
  end

  describe 'Static Attributes' do
    it 'has a Meeting Length (meeting_length)' do
      @settings.meeting_length.should == STATIC_SETTINGS['meeting_length']
    end

    it 'has a Meeting Gap (meeting_gap)' do
      @settings.meeting_gap.should == STATIC_SETTINGS['meeting_gap']
    end
  end

  describe 'Nested Attributes' do
    describe 'Meeting Times (meeting_times)' do
      context 'when getting' do
        it 'has a getter' do
          @settings.should respond_to(:meeting_times)
        end

        it 'returns the list of Time Slots concatenated by Meeting Length and Gap' do
          settings = Settings.instance
          Settings.stub(:instance).and_return(settings)
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
            settings.stub(:meeting_length).and_return(meeting_length)
            settings.stub(:meeting_gap).and_return(meeting_gap)
            settings.stub(:time_slots).and_return(time_slots)
            settings.meeting_times.should == result
          end
        end
      end

      context 'when setting' do
        it 'has a setter' do
          @settings.should respond_to(:meeting_times_attributes=)
        end

        it 'partitions the times into Time Slots by Meeting Length and Gap' do
          settings = Settings.instance
          Settings.stub(:instance).and_return(settings)
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
            settings.stub(:meeting_length).and_return(meeting_length)
            settings.stub(:meeting_gap).and_return(meeting_gap)
            settings.time_slots.delete_all
            time_slots_to_keep.map! {|t| settings.time_slots.create(t)}
            time_slots_to_remove.map! {|t| settings.time_slots.create(t)}
            settings.meeting_times_attributes = meeting_times
            settings.save!
            settings.time_slots.reload.map {|s| (s.begin)..(s.end)}.should == results
            (settings.time_slots & time_slots_to_keep).should == time_slots_to_keep
            (settings.time_slots & time_slots_to_remove).should be_empty
          end
        end
      end
    end
  end

  describe 'Singleton Model' do
    context 'getting an instance' do
      it 'builds an instance if one does not already exist' do
        Settings.destroy_all
        Settings.count.should == 0
        Settings.instance
        Settings.count.should == 1
      end
 
      it 'returns the existent instance if one exists' do
        Settings.instance.should_not be_a_new_record
      end
    end

    it 'does not otherwise allow a new instance to be created' do
      Settings.should_not respond_to(:new)
    end
  end

  context 'when building' do
    it 'by default has an Unsatisfied Admit Threshold of 0' do
      @settings.unsatisfied_admit_threshold.should == 0
    end

    it 'by default has a Faculty Weight of 1' do
      @settings.faculty_weight.should == 1
    end

    it 'by default has an Admit Weight of 1' do
      @settings.admit_weight.should == 1
    end

    it 'by default has a Rank Weight of 1' do
      @settings.rank_weight.should == 1
    end

    it 'by default has a Mandatory Weight of 1' do
      @settings.mandatory_weight.should == 1
    end

    it 'by default has a Disable Faculty From Making Changes flag of false' do
      @settings.disable_faculty.should be_false
    end

    it 'by default has a Disable Peer Advisors From Making Changes flag of false' do
      @settings.disable_peer_advisors.should be_false
    end
  end

  context 'when validating' do
    it 'is valid with valid attributes' do
      @settings.should be_valid
    end

    it 'is not valid with an invalid Unsatisfied Admit Threshold' do
      ['', -1, 'foobar'].each do |invalid_threshold|
        @settings.unsatisfied_admit_threshold = invalid_threshold
        @settings.should_not be_valid
      end
    end

    it 'is not valid with an invalid Faculty Weight' do
      ['', -1, 'foobar'].each do |invalid_weight|
        @settings.faculty_weight = invalid_weight
        @settings.should_not be_valid
      end
    end

    it 'is not valid with an invalid Admit Weight' do
      ['', -1, 'foobar'].each do |invalid_weight|
        @settings.admit_weight = invalid_weight
        @settings.should_not be_valid
      end
    end

    it 'is not valid with an invalid Rank Weight' do
      ['', -1, 'foobar'].each do |invalid_weight|
        @settings.rank_weight = invalid_weight
        @settings.should_not be_valid
      end
    end

    it 'is not valid with an invalid Mandatory Weight' do
      ['', -1, 'foobar'].each do |invalid_weight|
        @settings.mandatory_weight = invalid_weight
        @settings.should_not be_valid
      end
    end

    it 'is not valid without a Disable Faculty From Making Changes flag' do
      @settings.disable_faculty = nil
      @settings.should_not be_valid
    end

    it 'is not valid without a Disable Peer Advisors From Making Changes flag' do
      @settings.disable_peer_advisors = nil
      @settings.should_not be_valid
    end
  end
end
