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
  faculty = nil
  base_time = Time.parse(base)
  slot_length = slot_length.to_i.minutes
  debugger
  meetings.hashes.each do |meeting|
    faculty = Faculty.find_by_first_name_and_last_name(*(meeting[:faculty].split(/ /))) unless
      meeting[:faculty].blank?
    (0..2).each do |timeslot|
      time = base_time + slot_length * timeslot
      admit_name = meeting["time_#{timeslot}".to_sym]
      if !admit_name.blank?
        admit =  Admit.find_by_first_name_and_last_name(*(admit_name.split(/\s+/)))
        admit.meetings.create!(:time => time, :room => "Default room", :faculty_id => faculty.id)
      end
    end
  end
end
      
