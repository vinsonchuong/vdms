Given /^"([^"]*)" has the following meeting times:$/ do |division, time_ranges|
  division = Settings.instance.divisions.detect {|d| d.long_name == division}
  time_ranges.hashes.each do |time_range|
    division.time_slots.create(
      :begin => Time.zone.parse(time_range['begin']),
      :end => Time.zone.parse(time_range['end'])
    )
  end
end
