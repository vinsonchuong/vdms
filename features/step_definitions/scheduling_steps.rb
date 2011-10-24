Given /^the event has the following meeting time slots:$/ do |time_ranges|
  @event = @event || Factory.create(:event, :name => 'event')
  time_ranges.hashes.each do |time_range|
    @event.time_slots.create!(
      :begin => Time.zone.parse(time_range['begin']),
      :end => Time.zone.parse(time_range['end'])
    )
  end
end

Given /^the event has the following meeting times:$/ do |time_ranges|
  @event = @event || Factory.create(:event, :name => 'event')
  @event.meeting_times_attributes =
    time_ranges.hashes.map do |time_range|
      {
        :begin => Time.zone.parse(time_range['begin']),
        :end => Time.zone.parse(time_range['end'])
      }
    end
  @event.save!
end
