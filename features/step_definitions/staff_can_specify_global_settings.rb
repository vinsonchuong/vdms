When /^I add "([^"]*)" to "([^"]*)" to the meeting times$/ do |start, finish|
  start_time = Time.zone.parse(start)
  finish_time = Time.zone.parse(finish)
  index = Settings.instance.meeting_times.count

  select start_time.strftime('%Y'), :from => "settings_meeting_times_attributes_#{index}_begin_1i"
  select start_time.strftime('%B'), :from => "settings_meeting_times_attributes_#{index}_begin_2i"
  select start_time.day.to_s, :from => "settings_meeting_times_attributes_#{index}_begin_3i"
  select start_time.strftime('%H'), :from => "settings_meeting_times_attributes_#{index}_begin_4i"
  select start_time.strftime('%M'), :from => "settings_meeting_times_attributes_#{index}_begin_5i"

  select finish_time.strftime('%H'), :from => "settings_meeting_times_attributes_#{index}_end_4i"
  select finish_time.strftime('%M'), :from => "settings_meeting_times_attributes_#{index}_end_5i"
end

When /^I remove the meeting time beginning with "([^"]*)"$/ do |start|
  index = Settings.instance.meeting_times.index {|t| t.begin == Time.zone.parse(start)}
  check "settings_meeting_times_attributes_#{index}__destroy"
end

Then /^there should not be a meeting time beginning with "([^"]*)"$/ do |start|
  Settings.instance.meeting_times.none? {|t| t.begin == Time.zone.parse(start)}.should be_true
end
