When /^I flag the "([^"]*?)" to "([^"]*?)" slot as available$/ do |start, finish|
  index = Settings.instance.time_slots.index {|t| t.begin == Time.zone.parse(start) && t.end == Time.zone.parse(finish)}
  unless @faculty.nil?
    check "host_availabilities_attributes_#{index}_available"
  else
    check "visitor_availabilities_attributes_#{index}_available"
  end
end

When /^I set the room for the "([^"]*?)" to "([^"]*?)" slot to "([^"]*?)"$/ do |start, finish, room|
  index = Settings.instance.time_slots.index {|t| t.begin == Time.zone.parse(start) && t.end == Time.zone.parse(finish)}
  fill_in "host_availabilities_attributes_#{index}_room", :with => room
end
