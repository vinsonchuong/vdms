Given /^the event has the following meeting time slots:$/ do |time_ranges|
  settings = Settings.instance
  time_ranges.hashes.each do |time_range|
    settings.time_slots.create!(
      :begin => Time.zone.parse(time_range['begin']),
      :end => Time.zone.parse(time_range['end'])
    )
  end
end

Given /^the event has the following meeting times:$/ do |time_ranges|
  settings = Settings.instance
  settings.meeting_times_attributes =
    time_ranges.hashes.map do |time_range|
      {
        :begin => Time.zone.parse(time_range['begin']),
        :end => Time.zone.parse(time_range['end'])
      }
    end
  settings.save
end
