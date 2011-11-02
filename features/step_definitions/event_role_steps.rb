Given /^the following (host|visitor)s? (?:has|have) been added to the event:$/ do |role, people|
  roles = people.hashes.map do |attrs|
    attrs['person'] = Person.find_by_name(attrs['name'])
    attrs.delete('name')
    attrs['verified'] = true
    @event.send(role.tableize).create(attrs)
  end
  instance_variable_set("@#{role}", roles.first) if roles.count == 1
end

Given /^I want to manage the (host|visitor) named "([^"]*)"$/ do |role, name|
  instance_variable_set(
    "@#{role}",
    @event.send(role.tableize).find_by_person_id(Person.find_by_name(name))
  )
end

Given /^the (host|visitor) is unverified$/ do |role|
  instance_variable_get("@#{role}").update_attribute(:verified, false)
end

When /^(?:|I )follow "([^"]*)" for the (?:host|visitor) named "([^"]*)"$/ do |link, name|
  When %Q|I follow "#{link}" within "//*[.='#{name}']/.."|
end

When /^I flag the "([^"]*?)" to "([^"]*?)" meeting time as available$/ do |start, finish|
  prefix = @host.nil? ? 'visitor' : 'host'
  index = @event.time_slots.index {|t| t.begin == Time.zone.parse(start) && t.end == Time.zone.parse(finish)}
  check prefix + "_availabilities_attributes_#{index}_available"
end

When /^I set the room for the "([^"]*?)" to "([^"]*?)" meeting time to "([^"]*?)"$/ do |start, finish, room|
  index = @event.time_slots.index {|t| t.begin == Time.zone.parse(start) &&
                                       t.end == Time.zone.parse(finish)}
  fill_in "host_availabilities_attributes_#{index}_room", :with => room
end

When /^I rank the (?:visitor|host) named "([^"]*)" "([^"]*)"$/ do |name, rank|
  within(%Q|//*[.='#{name}']/..//select[substring(@id, string-length(@id) - 3) = 'rank']/..|) do
    select rank
  end
end

When /^I flag the visitor named "([^"]*)" as mandatory$/ do |name|
  within %Q|//*[.='#{name}']/..//input[substring(@id, string-length(@id) - 8) = 'mandatory']/..| do
    check /.*?/
  end
end

When /^I flag the visitor named "([^"]*)" as one on one$/ do |name|
  within %Q|//*[.='#{name}']/..//input[substring(@id, string-length(@id) - 9) = 'one_on_one']/..| do
    check /.*?/
  end
end

When /^I select "([^"]*)" time slots? for the visitor named "([^"]*)"$/ do |num_slots, name|
  within %Q|//*[.='#{name}']/..//select[substring(@id, string-length(@id) - 4) = 'slots']/..| do
    select num_slots
  end
end

When /^I flag the visitor named "([^"]*)" for removal$/ do |name|
  within %Q|//*[.='#{name}']/..//input[substring(@id, string-length(@id) - 6) = 'destroy']/..| do
    check /.*?/
  end
end

Given /^the host named "([^"]*)" has the following rankings:$/ do |name, rankings|
  host = @event.hosts.find_by_person_id(Person.find_by_name(name))
  rankings.hashes.each do |ranking|
    ranking['rankable'] = @event.visitors.find_by_person_id(Person.find_by_name(ranking['name']))
    ranking.delete('name')
    host.rankings.create(ranking)
  end
end
