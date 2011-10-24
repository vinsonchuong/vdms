Given /^the following events have been added:$/ do |events|
  events = events.hashes.map {|e| Factory.create(:event, e)}
  @event = events.first
end

When /^I add "([^"]*)" to "([^"]*)" to the meeting times$/ do |start, finish|
  start_time = Time.zone.parse(start)
  finish_time = Time.zone.parse(finish)
  index = @event.meeting_times.count

  select start_time.strftime('%Y'), :from => "event_meeting_times_attributes_#{index}_begin_1i"
  select start_time.strftime('%B'), :from => "event_meeting_times_attributes_#{index}_begin_2i"
  select start_time.day.to_s, :from => "event_meeting_times_attributes_#{index}_begin_3i"
  select start_time.strftime('%H'), :from => "event_meeting_times_attributes_#{index}_begin_4i"
  select start_time.strftime('%M'), :from => "event_meeting_times_attributes_#{index}_begin_5i"

  select finish_time.strftime('%H'), :from => "event_meeting_times_attributes_#{index}_end_4i"
  select finish_time.strftime('%M'), :from => "event_meeting_times_attributes_#{index}_end_5i"
end

When /^I remove the meeting time beginning with "([^"]*)"$/ do |start|
  index = @event.meeting_times.index {|t| t.begin == Time.zone.parse(start)}
  check "event_meeting_times_attributes_#{index}__destroy"
end

Then /^there (should not|should) be a meeting time beginning with "([^"]*)"$/ do |should, start|
  @event.meeting_times.none? {|t| t.begin == Time.zone.parse(start)}.should should == 'should' ?
                                                                            be_true :
                                                                            be_false
end
