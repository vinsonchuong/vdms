module MeetingsScheduler
  class << self

    def delete_old_meetings!
      puts 'Deleting all old Meetings...'
      Meeting.delete_all
    end

    def create_meetings_from_ranking_scores!
      start_time = Time.now
      puts 'Initializing all Meeting objects for ATTENDING faculties...'
      initialize_all_meetings

      puts 'Initialization complete.  Now populating and saving meetings by rank...'
      fill_up_meetings_from_rankings!(Ranking.by_rank)

      puts 'Initial meeting generation complete.  Now adding more meetings for unsatisfied admits (This will take a lot longer time)...'
      give_more_meetings_to_unsatisfied_admits!
      puts 'All meeting generation complete.'
      puts "Total algorithm runtime was #{(Time.now-start_time)/60} minutes."
    end

    # For debugging purposes
    def all_meetings
      @all_meetings
    end

    def test
      give_more_meetings_to_unsatisfied_admits!
    end


    private unless Rails.env == 'test'

    def initialize_all_meetings
      @all_meetings = Faculty.all.collect do |faculty|
        faculty.available_times.select(&:available).collect do |available_time|
          faculty.meetings.new(:time => available_time.begin,
                               :room => faculty.room_for(available_time.begin))
        end
      end
      @all_meetings.flatten!
    end

    def fill_up_meetings_from_rankings!(sorted_rankings)
      sorted_rankings.each do |ranking|
        faculty_meetings = get_all_meeting_spots_for_faculty(ranking.faculty)
        try_fit_ranking_to_timeslots!(chunks_of_consecutive_meetings(faculty_meetings), ranking)
      end
    end

    def try_fit_ranking_to_timeslots!(chunked_consecutive_faculty_meetings, ranking)
      num_consecutive_meetings = ranking.time_slots? ? ranking.time_slots : 1
      success = false

      # may add a num_consecutive_meetings.downto(1) in the future, so if n consecutive meetings cannot be found,
      # then try n-1 consecutive, and repeat til down to 1

      chunked_consecutive_faculty_meetings.each do |consecutive_meeting_chunk|
        consecutive_meeting_chunk.each_cons(num_consecutive_meetings) do |sub_meetings|
          break if (success = try_add_admit_to_consecutive_meetings!(ranking.admit, sub_meetings))
        end
        break if success
      end
    end

    def try_add_admit_to_consecutive_meetings!(admit, sub_meetings)
      return true if admit.maxed_out_number_of_meetings?

      sub_meetings.each{ |m| m.admits << admit unless m.admits.include?(admit) }
      if sub_meetings.collect{ |m| m.valid? }.include?(false)
        sub_meetings.each{ |m| m.admits.delete(admit) }
        return false
      else
        sub_meetings.each {|m| m.save!}
        return true
      end
    end

    def give_more_meetings_to_unsatisfied_admits!
      unsatisfied_admits = Admit.unsatisfied_admits
      unsatisfied_admits_meetings = {}

      unsatisfied_admits.each_with_index do |admit, index|
        unsatisfied_admits_meetings[admit.id] = matching_faculties_meetings(admit)
        puts "Done caching matching faculties\' meetings for unsatisfied admit #{index+1} of #{unsatisfied_admits.count}"
      end
      puts 'Finished caching the matching faculties\' meetings for each admit.'

      while not unsatisfied_admits.empty?
        # Dynamically re-sort unsatisfied admits, similar to the algorithm behind the SRTF queue
        unsatisfied_admits.each do |admit|
          if try_fit_admit_to_one_more_meeting!(admit, unsatisfied_admits_meetings[admit.id]) or !admit.unsatisfied?
            unsatisfied_admits_meetings[admit.id] = nil
            unsatisfied_admits -= [admit]
          end
        end
      end
      #Algorithm Description:
      #sort unsatisfied admits just once, then run through all admits to attempt to add one meeting ONCE,
      #deleting impossible or satisfied admits,THEN run through all remaining admits again

      # Cache the admit's matching faculties' meetings to a hash b/c that consumes most time

      # if the try_fit_admit_to_one_more_meeting! returns false, then it means that a meeting between an admit and
      # any matching professor cannot be set up b/c it will conflict with something, hence the admit
      # should be removed from the unsatisfied_admits queue,
      # to prevent infinite looping; the admit should also be removed if it has a satisfactory number of
      # meetings after the try_fit_admit_to_one_more_meeting!
    end

    def matching_faculties_meetings(admit)
      # cache this in first for later use in delete_if
      non_uniq_faculty_ids = admit.meetings.collect{ |m| m.faculty_id }
      uniq_matching_faculties = matching_faculties_for_admit(admit).delete_if do |faculty|
        non_uniq_faculty_ids.include? faculty.id
      end
      uniq_matching_faculties.collect{ |faculty| get_all_meeting_spots_for_faculty(faculty) }.flatten
    end

    def try_fit_admit_to_one_more_meeting!(admit, all_matching_faculty_meetings)
      all_matching_faculty_meetings.each do |meeting|
        meeting.admits << admit unless meeting.admits.include?(admit)
        unless meeting.valid?
            meeting.admits.delete(admit)
        else
          meeting.save!
          return true
        end
      end
      return false
    end

    def chunks_of_consecutive_meetings(faculty_meetings)
      sorted_meetings = faculty_meetings.sort_by{ |m| m.time }
      consecutively_chunked_meetings = [temp_meeting_chunk = []]

      sorted_meetings.each do |meeting|
        if temp_meeting_chunk.empty?
          temp_meeting_chunk << meeting
        elsif meeting.time == temp_meeting_chunk[-1].time + Settings.instance.meeting_length
          temp_meeting_chunk << meeting
        else
          consecutively_chunked_meetings << (temp_meeting_chunk = [meeting])
        end
      end
      consecutively_chunked_meetings
    end

    def get_all_meeting_spots_for_faculty(faculty)
      @all_meetings.find_all{ |m| m.faculty == faculty }
    end

    def matching_faculties_for_admit(admit)
      Faculty.attending_faculties.select do |faculty|
        faculty.areas.any?{ |area| admit.areas.include? area }
      end
    end

  end
end
