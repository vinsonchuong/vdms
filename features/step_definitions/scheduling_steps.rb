Given /^"([^"]*)" has the following meeting times:$/ do |division, time_ranges|
  division = Settings.instance.divisions.find_by_name(division)
  time_ranges.hashes.each do |time_range|
    division.available_times.create(
      :begin => Time.zone.parse(time_range['begin']),
      :end => Time.zone.parse(time_range['end'])
    )
  end
end
