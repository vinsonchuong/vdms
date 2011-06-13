When /^I add "([^"]*)" to "([^"]*)" to the meeting times for "([^"]*)"$/ do |start, finish, division|
  start_time = Time.zone.parse(start)
  finish_time = Time.zone.parse(finish)

  division_index = Settings.instance.divisions.index {|d| d.long_name == division}
  time_index = Settings.instance.divisions[division_index].time_slots.count

  select start_time.strftime('%Y'), :from => "settings_divisions_attributes_#{division_index}_time_slots_attributes_#{time_index}_begin_1i"
  select start_time.strftime('%B'), :from => "settings_divisions_attributes_#{division_index}_time_slots_attributes_#{time_index}_begin_2i"
  select start_time.day.to_s, :from => "settings_divisions_attributes_#{division_index}_time_slots_attributes_#{time_index}_begin_3i"
  select start_time.strftime('%H'), :from => "settings_divisions_attributes_#{division_index}_time_slots_attributes_#{time_index}_begin_4i"
  select start_time.strftime('%M'), :from => "settings_divisions_attributes_#{division_index}_time_slots_attributes_#{time_index}_begin_5i"

  select finish_time.strftime('%H'), :from => "settings_divisions_attributes_#{division_index}_time_slots_attributes_#{time_index}_end_4i"
  select finish_time.strftime('%M'), :from => "settings_divisions_attributes_#{division_index}_time_slots_attributes_#{time_index}_end_5i"
end

When /^I remove the "([^"]*)" meeting time beginning with "([^"]*)"$/ do |division, start|
  division_index = Settings.instance.divisions.index {|d| d.long_name == division}
  time_index = Settings.instance.divisions[division_index].time_slots.index {|t| t.begin == Time.zone.parse(start)}

  check "settings_divisions_attributes_#{division_index}_time_slots_attributes_#{time_index}__destroy"
end

Then /^"([^"]*)" should not have a meeting time beginning with "([^"]*)"$/ do |division, start|
  division = Settings.instance.divisions.detect {|d| d.long_name == division}
  division.time_slots.find_by_begin(Time.zone.parse(start)).should be_nil
end
