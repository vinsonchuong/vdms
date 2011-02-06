When /^I flag the "([^"]*?)" to "([^"]*?)" slot as available$/ do |start, finish|
  settings = Settings.instance
  unless @faculty.nil?
    index = @faculty.build_available_times(settings.meeting_times(@faculty.division), settings.meeting_length, settings.meeting_gap).index do |t|
      t.begin == Time.zone.parse(start) && t.end = Time.zone.parse(finish)
    end
    check "faculty_available_times_attributes_#{index}_available"
  else
    index = Admit.new.build_available_times(settings.divisions.map(&:available_times).flatten, settings.meeting_length, settings.meeting_gap).index do |t|
      t.begin == Time.zone.parse(start) && t.end = Time.zone.parse(finish)
    end
    check "admit_available_times_attributes_#{index}_available"
  end
end

When /^I set the room for the "([^"]*?)" to "([^"]*?)" slot to "([^"]*?)"$/ do |start, finish, room|
  settings = Settings.instance
  index = @faculty.build_available_times(settings.meeting_times(@faculty.division), settings.meeting_length, settings.meeting_gap).index do |t|
    t.begin == Time.zone.parse(start) && t.end = Time.zone.parse(finish)
  end
  fill_in "faculty_available_times_attributes_#{index}_room", :with => room
end
