# uncomment this line for using the genetic algorithm
# require 'meetings_scheduler_genetic_algorithm'

module MeetingsScheduler

  def self.delete_old_meetings!
    puts 'Deleting all old Meetings...'
    Meeting.delete_all
  end

  def self.create_meetings_from_ranking_scores!
    puts 'Initializing all Meeting objects for ATTENDING faculties...'
    @all_meetings = initialize_all_meetings

    puts 'Initialization complete.  Now populating and saving meetings...'
    fill_up_meetings_from_rankings!(Ranking.by_rank)

    puts 'Initial meeting generation complete.  Now adding more meetings for unsatisfied admits...'
    #fill_up_unsatisfied_meetings!
    puts 'All meeting generation complete.'
  end

  # For debugging purposes
  def self.all_meetings
    @all_meetings
  end

  def self.test(admit)
    matching_faculties_for_admit(admit)
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
      faculty_meetings = get_all_meeting_spots_for_faculty(ranking.faculty)
      try_fit_ranking_to_timeslots!(chunks_of_consecutive_meetings(faculty_meetings), ranking)
    end
  end

  def self.try_fit_ranking_to_timeslots!(chunked_consecutive_faculty_meetings, ranking)
    num_consecutive_meetings = ranking.time_slots? ? ranking.time_slots : 1
    success = false

    # may add a num_consecutive_meetings.downto(1) in the future, so if n consecutive meetings cannot be found,
    # then try n-1 consecutive, and repeat til down to 1

    chunked_consecutive_faculty_meetings.each do |consecutive_meeting_chunk|
      consecutive_meeting_chunk.each_cons(num_consecutive_meetings) do |sub_meetings|
=begin
        begin
          # the unless statement is required to prevent removal of possible meeting
          sub_meetings.each{ |meeting| meeting.add_admit!(ranking.admit) unless meeting.admits.include?(ranking.admit) }
        rescue
          # need this to ensure all prior successful meetings are removed as well; no need to re-raise exception
          sub_meetings.each{ |meeting| meeting.remove_admit!(ranking.admit) }
        else
          success = true
          break
        end
=end

        sub_meetings.each{ |m| m.admits << ranking.admit unless m.admits.include?(ranking.admit) }

        if sub_meetings.collect{ |m| m.valid? }.include?(false)
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

  def self.fill_up_unsatisfied_admits!
    unsatisfied_admits = Admit.unsatisfied_admits.sort_by{ |admit| -admit.meetings.count }
    unsatisfied_admits.each do |admit|
      matching_faculties = matching_faculties_for_admit(admit)
      try_fit_admit_to_more_meetings!(admit, matching_faculties)
    end
  end

  def try_fit_admit_to_more_meetings!(admit, matching_faculties)
    num_more_meetings_needed = admit.meetings.count - Settings.instance.unsatisfied_admit_threshold
    all_faculty_meetings = matching_faculties.collect{ |faculty| get_all_meeting_spots_for_faculty(faculty) }.flatten!
    all_faculty_meetings.each do |meeting|
      unless meeting.admits.include?(admit)
        meeting.admits << admit
        num_more_meetings_needed -= 1
      end

      if (not meeting.valid?) || (meeting.one_on_one_meeting? && meeting.admits.count > 1)
          meeting.admits.delete(admit)
        num_more_meetings_needed += 1
      else
        meeting.save!
      end

      if num_more_meetings_needed <= 0
        break
      end

    end
  end

  def self.chunks_of_consecutive_meetings(faculty_meetings)
    sorted_meetings = faculty_meetings.sort_by{|m| m.time} #faculty_meetings.select{|m| m.faculty.available_times.detect{|t| t.begin == m.time}.available}.sort_by{|m| m.time}
    temp_meeting_chunk = []
    consecutively_chunked_meetings = [temp_meeting_chunk]

    sorted_meetings.each do |meeting|
      if temp_meeting_chunk.empty?
        temp_meeting_chunk << meeting
      elsif meeting.time == temp_meeting_chunk[-1].time + Settings.instance.meeting_length
        temp_meeting_chunk << meeting
      else
        temp_meeting_chunk = [meeting]
        consecutively_chunked_meetings << temp_meeting_chunk
      end
    end

    consecutively_chunked_meetings
  end

  def self.get_all_meeting_spots_for_faculty(faculty)
    @all_meetings.find_all{ |m| m.faculty == faculty }
  end

  def self.matching_faculties_for_admit(admit)
    Faculty.attending_faculties.select do |faculty|
      faculty.areas.any?{ |area| admit.areas.include? area }
    end
  end

end
