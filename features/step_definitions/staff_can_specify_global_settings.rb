Given /^"([^"]*)" has the following meeting times:$/ do |division, time_ranges|
  division = Settings.instance.divisions.find_by_name(division)
  time_ranges.hashes.each do |time_range|
    division.available_times.create(
      :begin => Time.zone.parse(time_range['begin']),
      :end => Time.zone.parse(time_range['end'])
    )
  end
end

When /^I add "([^"]*)" to "([^"]*)" to the meeting times for "([^"]*)"$/ do |start, finish, division|
  division_index = Settings.instance.divisions.index {|d| d.name == division}
  time_index = Settings.instance.divisions[division_index].available_times.count

  fill_in "settings_divisions_attributes_#{division_index}_available_times_attributes_#{time_index}_begin", :with => start
  fill_in "settings_divisions_attributes_#{division_index}_available_times_attributes_#{time_index}_end", :with => finish
end

When /^I remove the "([^"]*)" meeting time beginning with "([^"]*)"$/ do |division, start|
  division_index = Settings.instance.divisions.index {|d| d.name == division}
  time_index = Settings.instance.divisions[division_index].available_times.index {|t| t.begin == Time.zone.parse(start)}

  check "settings_divisions_attributes_#{division_index}_available_times_attributes_#{time_index}__destroy"
end

Then /^"([^"]*)" should not have a meeting time beginning with "([^"]*)"$/ do |division, start|
  division = Settings.instance.divisions.find_by_name(division)
  division.available_times.find_by_begin(Time.zone.parse(start)).should be_nil
end
