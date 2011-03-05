class Meeting < ActiveRecord::Base
  belongs_to :faculty
  has_and_belongs_to_many :admits

  validates_datetime :time
  validates_presence_of :room
  validates_existence_of :faculty

  validate :no_conflicts, :if => Proc.new { |m| m.faculty && !m.admits.blank? }
  
  def self.generate
    MeetingsScheduler.delete_old_meetings!
    puts "GA initialize..."
    MeetingsScheduler::GeneticAlgorithm.initialize(self.factors_to_consider, self.fitness_scores_table)
    puts "GA running..."
    best_chromosome = MeetingsScheduler::GeneticAlgorithm.run(10, 1)
    MeetingsScheduler.create_meetings!(best_chromosome)
  end
  
  def to_s
    "Time: #{time.to_formatted_s(:long)}, faculty: #{faculty.full_name if faculty}, " <<
      "admits: #{admits.map { |a| a.full_name } if admits}"
  end

  def one_on_one_meeting?
    !(self.admits & self.faculty.ranked_one_on_one_admits).empty?
  end
  
  def remove_admit!(admit)
    self.admits -= [admit]
    self.save!
  end

  private unless Rails.env == "test"
  
  def no_conflicts
    fn = faculty.full_name
    tm = time.strftime('%I:%M%p')
    if (meeting = conflicts_with_one_on_one)
      errors.add_to_base "#{fn} has a 1-on-1 meeting with #{meeting.admits.first.full_name} at #{tm}."
    end
    errors.add_to_base "#{fn} is already seeing #{@faculty.max_admits_per_meeting} people at #{tm}, which is his/her maximum." if exceeds_max_admits_per_meeting
    errors.add_to_base "#{fn} is not available at #{tm}." unless faculty.available_at?(time)
    admits.each do |admit|
      errors.add_to_base "#{admit.full_name} is not available at #{tm}." unless admit.available_at?(time)
      if (m = admit.meeting_at_time(time)) && m != self
        errors.add_to_base "#{admit.full_name} is already meeting with #{m.faculty.full_name} at #{tm}."
      end
    end
  end

  def conflicts_with_one_on_one
    # conflicts if faculty has a meeting at this same time with a "1 on 1" ranked candidate
    other_meetings_this_timeslot.detect { |m| m.one_on_one_meeting? }
  end

  def exceeds_max_admits_per_meeting
    total_admits_this_timeslot = other_meetings_this_timeslot.inject(0) { |t,mtg| t + mtg.admits.length }
    self.admits.length + total_admits_this_timeslot > faculty.max_admits_per_meeting
  end
    
  def admit_unavailable(admit)
    unless 
      errors.add_to_base("#{admit.full_name} is not available at #{time.strftime('%I:%M%p')}.")
    end
  end
  
  def other_meetings_this_timeslot
    faculty.meetings.find(:all, :conditions => ['id != ? AND time = ?', self.id, self.time])
  end

  def self.fitness_scores_table
    { :is_meeting_possible_score          => 50000,
      :is_meeting_possible_penalty        => -50000,
      :faculty_ranking_weight_score       => 739,
      :faculty_ranking_default            => 0,
      :admit_ranking_weight_score         => 523,
      :admit_ranking_default              => 0,
      :area_match_score                   => 1532,
      :area_match_default                 => 0,
      :one_on_one_score                   => 50000,
      :one_on_one_penalty                 => 0,
      :one_on_one_default                 => 0,
      :mandatory_score                    => 50000,
      :mandatory_default                  => 0,
      :consecutive_timeslots_default      => 0,
      :consecutive_timeslots_weight_score => 10000
    }
  end
    
  def self.factors_to_consider
    { :attending_admits => self.attending_admits_hash,
      :faculties => self.faculties_hash,
      :total_number_of_seats => self.total_number_of_seats, 
      :number_of_spots_per_admit => 1,
      :chromosomal_inversion_probability => 0.5, 
      :point_mutation_probability => 0.3,
      :double_crossover_probability =>  0.2 
    }
  end
  
  def self.total_number_of_seats
    Faculty.attending_faculties.collect{ |faculty| faculty.available_times.select { |available_time| available_time.available? }.count * faculty.max_admits_per_meeting }.sum
  end
  
  def self.faculties_hash
    Faculty.attending_faculties.inject({}) {|faculties_hash, faculty| 
      faculties_hash.merge({ 
        faculty.id => { 
          :id => faculty.id,
          :area => faculty.area,
          :max_students_per_meeting => faculty.max_admits_per_meeting,
          :rankings => faculty.admit_rankings.collect {|admit_ranking| { 
            :rank => admit_ranking.rank, 
            :faculty_id => admit_ranking.faculty_id,
            :admit_id => admit_ranking.admit_id,
            :mandatory => admit_ranking.mandatory,
            :one_on_one => admit_ranking.one_on_one,
            :time_slots => admit_ranking.time_slots }},
          :schedule => faculty.available_times.all.select{ |available_time| available_time.available? }.collect {|available_time| { 
            :room => available_time.room.blank? ? faculty.default_room : available_time.room,
            :time_slot => available_time.begin..available_time.end}}}})}
  end
  
  def self.attending_admits_hash
    Admit.attending_admits.inject({}) {|attending_admits_hash, admit|
      attending_admits_hash.merge({ 
        admit.id => { 
          :id => admit.id,
          :name => admit.full_name,
          :area1 => admit.area1,
          :area2 => admit.area2,                    
          :rankings => admit.faculty_rankings.collect {|faculty_ranking| {
            :rank => faculty_ranking.rank, 
            :faculty_id => faculty_ranking.faculty_id,
            :admit_id => faculty_ranking.admit_id,
            :mandatory => faculty_ranking.mandatory,
            :one_on_one => faculty_ranking.one_on_one,
            :time_slots => faculty_ranking.time_slots }},
          :available_times => RangeSet.new(admit.available_times.collect{ |available_time| available_time.begin..available_time.end })}})}
  end
  
end
