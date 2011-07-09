Given /^the event has the following meeting time slots:$/ do |time_ranges|
  settings = Settings.instance
  time_ranges.hashes.each do |time_range|
    settings.time_slots.create!(
      :begin => Time.zone.parse(time_range['begin']),
      :end => Time.zone.parse(time_range['end'])
    )
  end
end
