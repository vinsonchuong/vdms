Given /^my first admit has the following meeting schedule:$/ do |admit_meeting_schedules|
  admit_meeting_schedules.hashes.each do |admit_meeting_schedule|
    @admit.meetings.create(
      :time => admit_meeting_schedule[:time],
      :room => admit_meeting_schedule[:room].to_s,
      :faculty_id => admit_meeting_schedule[:faculty_id].to_i
    )
  end
end
