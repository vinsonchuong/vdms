Given /^the following "([^"]*)" have been added:$/ do |role, people|
  @event = @event || Factory.create(:event, :name => 'Event')
  result = case role
    when 'Staff' then people.hashes.map {|p| Factory.create(:person, p.merge!(:role => 'administrator'))}
    when 'Peer Advisors' then people.hashes.map {|p| Factory.create(:person, p.merge!(:role => 'facilitator'))}
    when 'Faculty' then people.hashes.map {|p| @event.hosts.create(:person => Factory.create(:person, p))}
    when 'Admits' then people.hashes.map {|p| @event.visitors.create(:person => Factory.create(:person, p))}
  end
  instance_variable_set("@#{role.singularize.downcase.gsub(' ', '_')}", result.first)
end

Given /the "(.*)" for (.*) "(.*) (.*)" is (.*)/ do |attrib, role, first, last, value|
  klass = role.capitalize.constantize
  person = klass.send(:find_by_first_name_and_last_name,first,last)
  person.host.update_attribute(attrib.downcase.gsub(/ /,'_'), value)
end

Given /the staff have disabled faculty from making further changes/ do
  settings = Settings.instance
  settings.disable_faculty = true
  settings.save
end

Given /the staff have disabled peer advisors from making further changes/ do
  settings = Settings.instance
  settings.disable_peer_advisors = true
  settings.save
end
