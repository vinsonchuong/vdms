Given /^the following "([^"]*)" have been added to the event:$/ do |role, people|
  @event = @event || Factory.create(:event, :name => 'Event')
  case role
    when 'Hosts'
      @host = people.hashes.map do |person_attributes|
        person = Person.find_by_name(person_attributes[:name]) ||
          Factory.create(:person, person_attributes)
        @event.hosts.create(:person => person)
      end.first
    when 'Visitors'
      @visitor = people.hashes.map do |person_attributes|
        person = Person.find_by_name(person_attributes[:name]) ||
          Factory.create(:person, person_attributes)
        @event.visitors.create(:person => person)
      end.first
  end
end

Given /^the event has the following meeting times:$/ do |time_ranges|
  @event.meeting_times_attributes =
    time_ranges.hashes.map do |time_range|
      {
        :begin => Time.zone.parse(time_range['begin']),
        :end => Time.zone.parse(time_range['end'])
      }
    end
  @event.save!
end
