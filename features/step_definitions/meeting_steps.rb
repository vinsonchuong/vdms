Given /^my first admit has the following meeting schedule:$/ do |admit_meeting_schedules|
  admit_meeting_schedules.hashes.each do |admit_meeting_schedule|
    @admit.meetings.create(
      :time => admit_meeting_schedule[:time],
      :room => admit_meeting_schedule[:room].to_s,
      :faculty_id => admit_meeting_schedule[:faculty_id].to_i
    )
  end
end

Given /^the following (\d+)-minute meetings are scheduled starting at (.*):$/ do |slot_length,base,meetings|
  # prepopulate with empty meeting slots
  base_time = Time.zone.parse(base)
  slot_length = slot_length.to_i.minutes
  @faculty = nil
  meetings.hashes.each do |meeting|
    unless meeting[:faculty].blank? # if blank, continue using same faculty as before
      @faculty = Faculty.find_by_first_name_and_last_name(*(meeting[:faculty].split(/ /)))
    end
    (0..meetings.column_names.length-2).each do |timeslot|
      admit_name = meeting["time_#{timeslot}".to_sym]
      next if admit_name.blank?
      admit =  Admit.find_by_first_name_and_last_name(*(admit_name.split(/\s+/)))
      time = base_time + slot_length * timeslot
      @faculty.available_times.build(:begin => time, :end => time+slot_length-1, :available => true) unless @faculty.available_times.find_by_begin_and_available(time,true)
      admit.available_times.build(:begin => time, :end => time+slot_length, :available => true) unless admit.available_times.find_by_begin_and_available(time,true)
      # if already a meeting at this time, add the admit to it; else create new mtg
      m = @faculty.meetings.find_by_time(time) ||
        @faculty.meetings.create!(:time => time, :room => 'Default')
      m.admits << admit
      # make sure faculty's max admits/slot is bumped up to allow this
      @faculty.max_admits_per_meeting = m.admits.length
      @faculty.save!
      m.save!
    end
  end
end
      
def create_empty_meetings(faculty, start_time, length, num)
  0.upto(num-1) do |i|
    time = start_time + length * i
    slot = Factory.create(:available_time, :available => true, :begin => time, :end => time+length-1)
    faculty.available_times << slot
    faculty.meetings.create!(:time => time, :room => 'Default')
    faculty.save!
  end
end
      
