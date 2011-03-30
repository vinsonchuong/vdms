# uncomment this line for using the genetic algorithm
# require 'meetings_scheduler_genetic_algorithm'

module MeetingsScheduler

  def self.delete_old_meetings!
    puts "Deleting all old Meetings..."
    Meeting.delete_all
  end

  def self.create_meetings_from_ranking_scores!
    puts "Initializing all Meeting objects for ATTENDING faculties..."
    @all_meetings = initialize_all_meetings
    puts "Initialization complete.  Now populating and saving meetings..."
    fill_up_meetings_from_rankings!(Ranking.by_rank)
    puts "Initial meeting generation complete.  Now adding more meetings for unsatisfied admits..."
    fill_up_unsatisfied_meetings!
    puts "All meeting generation complete."
  end

  # For debugging purposes
  def self.all_meetings
    @all_meetings
  end


  private unless Rails.env == 'test'

  def self.initialize_all_meetings
    @all_meetings = Faculty.all.collect do |faculty|
      faculty.available_times.select(&:available).collect do |available_time|
        faculty.meetings.new(:time => available_time.begin,
                             :room => faculty.room_for(available_time.begin))
      end
    end
    @all_meetings.flatten!
  end

  def self.fill_up_meetings_from_rankings!(sorted_rankings)
    sorted_rankings.each do |ranking|
      faculty_meetings = get_all_meeting_spots_for_faculty(ranking)
      try_fit_ranking_to_timeslots!(faculty_meetings, ranking)
    end
  end

  def self.try_fit_ranking_to_timeslots!(faculty_meetings, ranking)
    num_consecutive_meetings = ranking.time_slots? ? ranking.time_slots : 1
    chunked_consecutive_faculty_meetings = chunks_of_consecutive_meetings(faculty_meetings)
    success = false

    # may add a num_consecutive_meetings.downto(1) in the future

    chunked_consecutive_faculty_meetings.each do |consecutive_meeting_chunk|
      consecutive_meeting_chunk.each_cons(num_consecutive_meetings) do |sub_meetings|

        sub_meetings.each{ |m| m.admits << ranking.admit unless m.admits.include?(ranking.admit) }

        if sub_meetings.collect{ |m| m.valid? }.include?(false) || sub_meetings.any?{ |m| m.one_on_one_meeting? && m.admits.count > 1 }
          sub_meetings.each{ |m| m.admits.delete(ranking.admit) }
        else
          success = true
          sub_meetings.each {|m| m.save!}
          break
        end
      end

      if success
        break
      end
    end
  end

  def self.fill_up_unsatisfied_meetings!
  end

  def self.chunks_of_consecutive_meetings(faculty_meetings)
    sorted_meetings = faculty_meetings.sort_by{|m| m.time} #faculty_meetings.select{|m| m.faculty.available_times.detect{|t| t.begin == m.time}.available}.sort_by{|m| m.time}
    temp_meeting_chunk = []
    consecutively_chunked_meetings = [temp_meeting_chunk]

    sorted_meetings.each do |meeting|
      if temp_meeting_chunk.empty?
        temp_meeting_chunk << meeting
      end

      if meeting.time == temp_meeting_chunk[-1].time + Settings.instance.meeting_length
        temp_meeting_chunk << meeting
      else
        temp_meeting_chunk = [meeting]
        consecutively_chunked_meetings << temp_meeting_chunk
      end
    end

    consecutively_chunked_meetings
  end

  def self.get_all_meeting_spots_for_faculty(ranking)
    @all_meetings.find_all{ |m| m.faculty == ranking.faculty }
  end

end
