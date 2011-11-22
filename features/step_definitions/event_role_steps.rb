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

Given /^the (host|visitor) named "([^"]*)" has the following rankings:$/ do |role, name, rankings|
  role = @event.send(role.tableize).find_by_person_id(Person.find_by_name(name))
  rankings.hashes.each do |ranking|
    ranking['rankable'] = @event.send(role.class == Host ? 'visitors' : 'hosts')
                          .find_by_person_id(Person.find_by_name(ranking['name']).id)
    ranking.delete('name')
    role.rankings.create(ranking)
  end
end

Given /I have the following rankings:/ do |rankings|
  Given %Q|the #{@host.nil? ? 'visitor' : 'host'} named "My Name" has the following rankings:|, rankings
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
  within(:xpath, %Q|//*[.='#{name}']/..//select[contains(@id, 'rank')]/..|) do
    select rank
  end
end

When /^I flag the visitor named "([^"]*)" as mandatory$/ do |name|
  find(:xpath, %Q|//*[.='#{name}']/..//input[contains(@id, 'mandatory')]|).set(true)
end

When /^I flag the visitor named "([^"]*)" as one on one$/ do |name|
  find(:xpath, %Q|//*[.='#{name}']/..//input[contains(@id, 'one_on_one')]|).set(true)
end

When /^I select "([^"]*)" time slots? for the visitor named "([^"]*)"$/ do |num_slots, name|
  within(:xpath, %Q|//*[.='#{name}']/..//select[contains(@id, 'slots')]|) do
    select num_slots
  end
end

When /^I flag the (?:host|visitor) named "([^"]*)" for removal$/ do |name|
  find(:xpath, %Q|//*[.='#{name}']/..//input[contains(@id, 'destroy')]|).set(true)
end
