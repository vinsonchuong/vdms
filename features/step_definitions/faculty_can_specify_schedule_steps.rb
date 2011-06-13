When /^I flag the "([^"]*?)" to "([^"]*?)" slot as available$/ do |start, finish|
  settings = Settings.instance
  unless @faculty.nil?
    index = @faculty.build_time_slots(settings.meeting_times(@faculty.division), settings.meeting_length, settings.meeting_gap).index do |t|
      t.begin == Time.zone.parse(start) && t.end = Time.zone.parse(finish)
    end
    check "faculty_time_slots_attributes_#{index}_available"
  else
    index = Admit.new.build_time_slots(settings.divisions.map(&:time_slots).flatten, settings.meeting_length, settings.meeting_gap).index do |t|
      t.begin == Time.zone.parse(start) && t.end = Time.zone.parse(finish)
    end
    check "admit_time_slots_attributes_#{index}_available"
  end
end

When /^I set the room for the "([^"]*?)" to "([^"]*?)" slot to "([^"]*?)"$/ do |start, finish, room|
  settings = Settings.instance
  index = @faculty.build_time_slots(settings.meeting_times(@faculty.division), settings.meeting_length, settings.meeting_gap).index do |t|
    t.begin == Time.zone.parse(start) && t.end = Time.zone.parse(finish)
  end
  fill_in "faculty_time_slots_attributes_#{index}_room", :with => room
end
