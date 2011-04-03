=begin
require 'spec_helper'

describe MeetingsScheduler::GeneticAlgorithm::Nucleotide do
  before(:each) do
    @fitness_scores_table = create_valid_fitness_scores_table
    MeetingsScheduler::GeneticAlgorithm::Nucleotide.set_fitness_scores_table(@fitness_scores_table)
  end

  describe 'Nucleotide attributes' do
    before(:each) do
      @faculty_hash = create_valid_faculty_hash(@faculty_id = rand(100))
      @admit_hash = create_valid_admit_hash(@admit_id = rand(100))
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty_hash, @schedule_index = 5, @admit_hash)
    end

    it 'has a schedule_index' do
      @nucleotide.should respond_to(:schedule_index)
    end

    it "responds to faculty" do
      @nucleotide.should respond_to(:faculty)
    end

    it "responds to faculty_id" do
      @nucleotide.should respond_to(:faculty_id)
    end

    it "responds to admit" do
      @nucleotide.should respond_to(:admit)
    end

    it "responds to admit_id" do
       @nucleotide.should respond_to(:admit_id)
    end

    it "should return 15 when calling nucleotide.faculty_id with its faculty[:id] = 15" do
      @nucleotide.faculty_id.should == @faculty_id
    end

    it "should return 20 when calling nucleotide.admit_id with its admit_id[:id] = 20" do
      @nucleotide.admit_id.should == @admit_id
    end

    it 'is comparable to another nucleotide' do
      @nucleotide.==(MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty_hash, @schedule_index, @admit_hash)).should == true
    end
  end

  describe 'instance method: fitness' do
    before(:each) do
      @faculty_hash, @admit_hash, @schedule_index = mock('faculty'), mock('admit'), rand(100)
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty_hash, @schedule_index, @admit_hash)
      @nucleotide.stub!(:is_meeting_possible_score).and_return(@is_meeting_possible_score = rand(100))
    end
    it 'should calculate nucleotide-scale scores if meeting is physically possible' do
      @nucleotide.stub!(:is_meeting_possible?).and_return(true)
      @nucleotide.stub!(:faculty_preference_score).and_return(@faculty_preference_score = rand(100))
      @nucleotide.stub!(:admit_preference_score).and_return(@admit_preference_score = rand(100))
      @nucleotide.stub!(:area_match_score).and_return(@area_match_score = rand(100))
      @nucleotide.fitness.should == @is_meeting_possible_score + @faculty_preference_score + @admit_preference_score + @area_match_score
    end

    it 'should return is_meeting_possible penalty if meeting is physically impossible' do
      @nucleotide.stub!(:is_meeting_possible?).and_return(false)
      @nucleotide.fitness.should == @is_meeting_possible_score
    end
  end

  describe 'instance method: get_faculty_ranking' do
    it 'should return nil if nucleotide contains nil admit' do
      MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(mock('faculty'), rand(100), nil).get_faculty_ranking.should == nil
    end

    it 'should return the ADMIT\'s ranking that contains the faculty' do
      @faculty = { :id => (@faculty_id = rand(100)) }
      @ranking = { :faculty_id  => @faculty_id }
      @admit = { :rankings => (rand(20).times.collect{ |id| { :faculty_id => "Non-id #{id}" }} + [@ranking]).shuffle.shuffle }
      MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty,rand(100),@admit).get_faculty_ranking.inspect.should == @ranking.inspect
    end
  end

  describe 'instance method: get_admit_ranking' do
    it 'should return nil if nucleotide contains nil admit' do
      MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(mock('faculty'), rand(100), nil).get_admit_ranking.should == nil
    end

    it 'should return the FACULTY\'s ranking that contains the admit' do
      @admit = { :id => (@admit_id = rand(100)) }
      @ranking = { :admit_id  => @admit_id }
      @faculty = { :rankings => (rand(20).times.collect{ |id| { :admit_id => "Non-id #{id}" }} + [@ranking]).shuffle.shuffle }
      MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty,rand(100),@admit).get_admit_ranking.inspect.should == @ranking.inspect
    end
  end

  describe 'instance method: is_meeting_possible?' do
    before(:each) do
      @admit = create_valid_admit_hash(rand(100))
      @faculty = create_valid_faculty_hash(rand(100))
    end

    it 'should return false if nucleotide contains nil admit' do
      MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(mock('faculty'), rand(100), nil).is_meeting_possible?.should == false
    end

    it 'should return true if nucleotide encodes for a physically possible meeting' do
      @schedule_index = 1
      MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty, @schedule_index, @admit).is_meeting_possible?.should == true
    end

    it 'should return false if nucleotide encodes for a physically impossible meeting' do
      @schedule_index = 0
      MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty, @schedule_index, @admit).is_meeting_possible?.should == false
    end
  end

  describe 'instance method: mandatory?' do
    [true, false].each do |val|
      it "should return #{val} if the faculty\'s admit ranking\'s mandatory attribute is #{val}" do
        @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(mock('faculty'), rand(100), mock('admit'))
        @nucleotide.stub!(:get_admit_ranking).and_return({ :mandatory => val })
        @nucleotide.mandatory?.should == val
      end
    end

    it 'should return false if faculty has no ranking for the admit' do
        @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(mock('faculty'), rand(100), mock('admit'))
        @nucleotide.stub!(:get_admit_ranking).and_return(nil)
        @nucleotide.mandatory?.should == false
    end
  end

  describe 'instance method: one_on_one_meeting_requested?' do
    before(:each) do
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(mock('faculty'), rand(100), mock('admit'))
    end

    it 'should return false if nucleotide contains nil admit' do
      @nucleotide.stub!(:get_admit_ranking).and_return(nil)
      @nucleotide.one_on_one_meeting_requested?.should == false
    end

    [true, false].each do |val|
      it "should return #{val} if the ranking's one_on_one request is #(val}" do
        @nucleotide.stub!(:get_admit_ranking).and_return({:one_on_one => val})
        @nucleotide.one_on_one_meeting_requested?.should == val
      end
    end
  end

  describe 'instance method: num_timeslots_requested' do
    before(:each) do
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(mock('faculty'), rand(100), mock('admit'))
    end

    it 'should return 0 if nucleotide contains nil admit or no admit_ranking exists' do
      @nucleotide.stub!(:get_admit_ranking).and_return(nil)
      @nucleotide.num_timeslots_requested.should == 0
    end

    it 'should return the number of timeslots requested' do
      @nucleotide.stub!(:get_admit_ranking).and_return({:time_slots => (@time_slots = rand(100)) })
      @nucleotide.num_timeslots_requested.should == @time_slots
    end
  end

  describe 'instance method: is_meeting_possible_score' do
    before(:each) do
      @faculty_hash, @admit_hash, @schedule_index = mock('faculty'), mock('admit'), rand(100)
    end

    it 'should return a score if a meeting arrangement defined by a single nucleotide is physically possible' do
      @schedule_index = 1
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty, @schedule_index, @admit)
      @nucleotide.stub!(:is_meeting_possible?).and_return(true)
      @nucleotide.is_meeting_possible_score.should == @fitness_scores_table[:is_meeting_possible_score]
    end

    it 'should return a penalty if a meeting arrangement defined by a single nucleotide is physically impossible' do
      @schedule_index = 0
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty, @schedule_index, @admit)
      @nucleotide.stub!(:is_meeting_possible?).and_return(false)
      @nucleotide.is_meeting_possible_score.should == @fitness_scores_table[:is_meeting_possible_penalty]
    end
  end

  describe 'instance method: area_match_score' do
    it 'should return the appropriate points when a faculty\'s areas of research matches one of an admit\'s areas of interest' do
      @admit, @faculty = create_valid_admit_hash(1), create_valid_faculty_hash(1)
      @faculty[:area], @admit[:area1], @admit[:area2] = 'subjectA', 'subjectA', 'subjectC'
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty, rand(100), @admit)
      @nucleotide.area_match_score.should == @fitness_scores_table[:area_match_score]
    end

    it 'should return the appropriate default when a faculty\'s areas of research does not match any one of an admit\'s areas of interest' do
      @admit, @faculty = create_valid_admit_hash(1), create_valid_faculty_hash(1)
      @faculty[:area], @admit[:area1], @admit[:area2] = 'subjectA', 'subjectB', 'subjectC'
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty, rand(100), @admit)
      @nucleotide.area_match_score.should == @fitness_scores_table[:area_match_default]
    end
  end

  describe 'instance method: admit_preference_score' do
    before(:each) do
      @admit, @faculty = create_valid_admit_hash(1), create_valid_faculty_hash(1)
      @faculty[:rankings] = (@ranking = { :rank => rand(100) })
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty, rand(100), @admit)
    end

    it 'should compute a rank-weighted score if an admit is among a FACULTY\'s ranking' do
      @nucleotide.stub!(:get_admit_ranking).and_return(@ranking)
      @nucleotide.should_receive(:get_admit_ranking).once
      @nucleotide.stub!(:mandatory_meeting_score).and_return(@mandatory_meeting_score = rand(100))
      @nucleotide.admit_preference_score.should ==
        @fitness_scores_table[:admit_ranking_weight_score] * (@faculty[:rankings].count+1 - @ranking[:rank]) + @mandatory_meeting_score
    end
    it 'should return a default score if an admit is not among a FACULTY\'s ranking' do
      @nucleotide.stub!(:get_admit_ranking).and_return(nil)
      @nucleotide.admit_preference_score.should == @fitness_scores_table[:admit_ranking_default]
    end
  end

  describe 'instance method: faculty_preference_score' do
    before(:each) do
      @admit, @faculty = create_valid_admit_hash(1), create_valid_faculty_hash(1)
      @admit[:rankings] = (@ranking = { :rank => rand(100) })
      @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(@faculty, rand(100), @admit)
    end

    it 'should compute a rank-weighted score if an admit is among a FACULTY\'s ranking' do
      @nucleotide.stub!(:get_faculty_ranking).and_return(@ranking)
      @nucleotide.should_receive(:get_faculty_ranking).once
      @nucleotide.faculty_preference_score.should ==
        @fitness_scores_table[:faculty_ranking_weight_score] * (@admit[:rankings].count+1 - @ranking[:rank])
    end
    it 'should return a default score if an admit is not among a FACULTY\'s ranking' do
      @nucleotide.stub!(:get_faculty_ranking).and_return(nil)
      @nucleotide.faculty_preference_score.should == @fitness_scores_table[:faculty_ranking_default]
    end
  end

  describe 'instance method: mandatory_meeting_score' do
    [true, false].each do |val|
      it "should return the appropriate points for whether a FACULTY\'s admit ranking is marked #{val}" do
        score = val ? @fitness_scores_table[:mandatory_score] : @fitness_scores_table[:mandatory_default]
        @nucleotide = MeetingsScheduler::GeneticAlgorithm::Nucleotide.new(mock('faculty'), rand(100), mock('admit'))
        @nucleotide.stub!(:mandatory?).and_return(val)
        @nucleotide.mandatory_meeting_score.should == score
      end
    end
  end
end


## Helper Methods to set up valid factors_to_consider and fitness_scores_table hashes

def create_valid_factors_hash
  double_crossover_probability = rand
  chromosomal_inversion_probability = rand
  point_mutation_probability = rand

  while chromosomal_inversion_probability + point_mutation_probability > 1
    point_mutation_probability = rand
  end


  faculties = 4.times.collect{ |id| create_valid_faculty_hash(id+100) }
  attending_admits = 4.times.collect{ |id| create_valid_admit_hash(id) }

  faculties = {
    faculties[0][:id] => faculties[0],
    faculties[1][:id] => faculties[1],
    faculties[2][:id] => faculties[2],
    faculties[3][:id] => faculties[3]
  }

  attending_admits = {
    attending_admits[0][:id] => attending_admits[0],
    attending_admits[1][:id] => attending_admits[1],
    attending_admits[2][:id] => attending_admits[2],
    attending_admits[3][:id] => attending_admits[3]
  }

  lowest_rank_possible = 5

  total_number_of_seats = faculties.collect do |faculty_id, faculty|
    faculty[:schedule].collect{ |room_timeslot_pair| faculty[:max_students_per_meeting].times.collect }
  end

  total_number_of_seats = total_number_of_seats.flatten.count
  #total_number_of_meetings = faculties.collect{ |faculty_id, faculty| faculty[:schedule].count }.inject(:+)

  number_of_spots_per_admit = (total_number_of_seats / attending_admits.length).floor - 1

  return {
    :total_number_of_seats             => total_number_of_seats,
    :number_of_spots_per_admit         => number_of_spots_per_admit,
    :chromosomal_inversion_probability => chromosomal_inversion_probability,
    :point_mutation_probability        => point_mutation_probability,
    :double_crossover_probability      => double_crossover_probability,
    :lowest_rank_possible              => lowest_rank_possible,
    :attending_admits                  => attending_admits,
    :faculties                         => faculties
  }
end


def create_valid_solution_string(factors_to_consider)
  attending_admits = factors_to_consider[:attending_admits]
  total_number_of_seats = factors_to_consider[:total_number_of_seats]
  number_of_spots_per_admit = factors_to_consider[:number_of_spots_per_admit]

  solution_string = Array.new(total_number_of_seats)
  admit_ids = (attending_admits.keys * number_of_spots_per_admit)

  if admit_ids.length < total_number_of_seats
    remaining_empty_seats = total_number_of_seats - admit_ids.length
    admit_ids += remaining_empty_seats.times.collect{ admit_ids.sample }
  end

  solution_string[0...solution_string.length] = admit_ids.shuffle.shuffle[0...solution_string.length] if total_number_of_seats > 0
  return solution_string
end

def create_valid_faculty_hash(id)
  {
    :id                       => id,
    :max_students_per_meeting => rand(4)+1,
    :admit_rankings           => [],
    :schedule                 => [{:room => 'room1', :time_slot => 1.hour.from_now..5.hours.from_now},
                                  {:room => 'room2', :time_slot => 32.hours.from_now..45.hours.from_now}]
  }
end

def create_valid_admit_hash(id)
  {
    :id              => id,
    :name            => "Admit<#{id}>",
    :ranking         => [],
    :available_times => RangeSet.new([1.day.from_now..2.days.from_now,
                                      3.days.from_now..4.days.from_now])
  }
end

def create_valid_fitness_scores_table
  return {
    :is_meeting_possible_score       => rand(100),
    :is_meeting_possible_penalty     => -rand(100),
    :faculty_ranking_weight_score => rand(100),
    :faculty_ranking_default      => rand(100),
    :admit_ranking_weight_score   => rand(100),
    :admit_ranking_default        => rand(100),
    :area_match_score             => rand(100),
    :area_match_default           => rand(100),
    :one_on_one_score             => rand(100),
    :one_on_one_penalty           => -rand(100),
    :one_on_one_default           => rand(100),
    :mandatory_score              => rand(100),
    :mandatory_default            => rand(100)
  }
end
=end