When /^I flag the "([^"]*?)" to "([^"]*?)" slot as available$/ do |start, finish|
  index = @faculty.build_available_times.index {|t| t.begin == Time.zone.parse(start) && t.end = Time.zone.parse(finish)}
  check "faculty_available_times_attributes_#{index}_available"
end

When /^I set the room for the "([^"]*?)" to "([^"]*?)" slot to "([^"]*?)"$/ do |start, finish, room|
  index = @faculty.build_available_times.index {|t| t.begin == Time.zone.parse(start) && t.end = Time.zone.parse(finish)}
  fill_in "faculty_available_times_attributes_#{index}_room", :with => room
end
