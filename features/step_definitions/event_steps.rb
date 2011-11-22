Given /^the following (?:event has|events have) been added:$/ do |events|
  events = events.hashes.map {|e| Factory.create(:event, e)}
  @event = events.first if events.count == 1
end

Given /^I want to (?:manage|view) the event named "([^"]*)"$/ do |name|
  @event = Event.find_by_name(name)
end

Given /^the event has the following meeting times?:$/ do |time_ranges|
  time_ranges.hashes.each do |time_range|
    @event.time_slots.create({
     :begin => Time.zone.parse(time_range['begin']),
     :end => Time.zone.parse(time_range['end'])
    })
  end
end

Given /the administrators have disabled hosts from making further changes/ do
  @event.update_attribute(:disable_hosts, true)
end

Given /the administrators have disabled facilitators from making further changes / do
  @event.update_attribute(:disable_facilitators, true)
end

When /^(?:|I )follow "([^"]*)" for the event named "([^"]*)"$/ do |link, name|
  step %Q|I follow "#{link}" within "//*[.='#{name}']/.."|
end

When /^I add "([^"]*)" to "([^"]*)" to the meeting times$/ do |start, finish|
  start = Time.zone.parse(start)
  finish = Time.zone.parse(finish)
  index = @event.meeting_times.count

  select start.strftime('%Y'), :from => "event_meeting_times_attributes_#{index}_begin_1i"
  select start.strftime('%B'), :from => "event_meeting_times_attributes_#{index}_begin_2i"
  select start.day.to_s, :from => "event_meeting_times_attributes_#{index}_begin_3i"
  select start.strftime('%H'), :from => "event_meeting_times_attributes_#{index}_begin_4i"
  select start.strftime('%M'), :from => "event_meeting_times_attributes_#{index}_begin_5i"

  select finish.strftime('%H'), :from => "event_meeting_times_attributes_#{index}_end_4i"
  select finish.strftime('%M'), :from => "event_meeting_times_attributes_#{index}_end_5i"
end

When /^I remove the "([^"]*)" to "([^"]*)" meeting time$/ do |start, finish|
  index = @event.meeting_times.index {|t| t.begin == Time.zone.parse(start) &&
                                          t.end == Time.zone.parse(finish)}
  check "event_meeting_times_attributes_#{index}__destroy"
end

Then /^there (should not|should) be a "([^"]*)" to "([^"]*)" meeting time$/ do |should, start, finish|
  @event.meeting_times.none? {|t| t.begin == Time.zone.parse(start) &&
                                  t.end == Time.zone.parse(finish)}
end
