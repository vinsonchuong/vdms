Given /^"(.*) (.*)" is available at (.*)$/ do |first,last,time|
  time = Time.zone.parse(time)
  p = Person.find_by_first_name_and_last_name(first,last)
  p = p.class == Faculty ? p.host : p.visitor
  t = Settings.instance.time_slots.find_by_begin(time)
  p.availabilities.find_by_time_slot_id(t).update_attribute(:available, true)
end

Given /^my first admit has the following meeting schedule:$/ do |admit_meeting_schedules|
  admit_meeting_schedules.hashes.each do |admit_meeting_schedule|
    @admit.meetings.create(
      :time => Time.zone.parse(admit_meeting_schedule[:time]),
      :room => admit_meeting_schedule[:room].to_s,
      :faculty_id => admit_meeting_schedule[:faculty_id].to_i
    )
  end
end

Given /^the following (\d+)-minute meetings are scheduled starting at (.*):$/ do |slot_length,base,meetings|
  base_time = Time.zone.parse(base)
  @slot_length = slot_length.to_i.minutes
  @faculty = nil
  meetings.hashes.each do |meeting|
    unless meeting[:faculty].blank? # if blank, continue using same faculty as before
      @faculty = Faculty.find_by_first_name_and_last_name(*(meeting[:faculty].split(/ /)))
    end
    (0..meetings.column_names.length-2).each do |timeslot|
      admit_name = meeting["time_#{timeslot}".to_sym]
      next if admit_name.blank?
      admit =  Admit.find_by_first_name_and_last_name(*(admit_name.split(/\s+/)))
      time = base_time + @slot_length * timeslot
      time_slot = TimeSlot.find_by_begin(time) || TimeSlot.create!(:events => Settings.instance, :begin => time, :end => time+@slot_length-1)
      fa = @faculty.host.availabilities.find_by_time_slot_id(time_slot.id)
      fa.available || fa.update_attribute(:available, true)
      aa = admit.visitor.availabilities.find_by_time_slot_id(time_slot.id)
      # make sure faculty's max admits/slot is bumped up to allow this
      @faculty.host.max_visitors_per_meeting += 1;
      @faculty.save!
      Meeting.create!(:host_availability => fa, :visitor_availability => aa)
    end
  end
end

When /^I check the remove box for admit "(.*) (.*)" at (.*)/ do |first,last,time|
  @admit = Admit.find_by_first_name_and_last_name(first,last)
  time_slot = Settings.instance.time_slots.find_by_begin(Time.zone.parse(time))
  @host_availability = time_slot.host_availabilities.find_by_schedulable_id(Faculty.all.first.host.id)
  @visitor_availability = time_slot.visitor_availabilities.find_by_schedulable_id(@admit.visitor.id)
  @meeting = @host_availability.meetings.find_by_visitor_availability_id(@visitor_availability.id)
  i1 = Faculty.all.first.host.availabilities.index(@host_availability)
  i2 = @host_availability.meetings.index(@meeting)
  When %Q{I check "host_availabilities_attributes_#{i1}_meetings_attributes_#{i2}__destroy"}
end

When /^I select "(.*)" from the menu for the (.*) meeting with "(.*) (.*)"$/ do |admit,time,fac_first,fac_last|
  @time = Time.zone.parse(time)
  @faculty = Faculty.find_by_first_name_and_last_name(fac_first,fac_last)
  time_slot = Settings.instance.time_slots.find_by_begin(@time)
  availability = @faculty.host.availabilities.find_by_time_slot_id(time_slot.id)
  ai = @faculty.host.availabilities.index {|a| a.time_slot == time_slot}
  mi = availability.meetings.count + 1
  select(admit, :from => "host_availabilities_attributes_#{ai}_meetings_attributes_#{mi}_visitor_availability_id")
end

Then /^faculty "(.*) (.*)" should (not |)?have a meeting with "(.*) (.*)" at (.*)/ do |fac_first,fac_last,neg,first,last,time|
  @faculty = Faculty.find_by_first_name_and_last_name(fac_first,fac_last)
  @admit = Admit.find_by_first_name_and_last_name(first,last)
  @time_slot = Settings.instance.time_slots.find_by_begin(Time.zone.parse(time))
  @host_availability = @faculty.host.availabilities.find_by_time_slot_id(@time_slot.id)
  @visitor_availability = @admit.visitor.availabilities.find_by_time_slot_id(@time_slot.id)
  meeting = @host_availability.meetings.find_by_visitor_availability_id(@visitor_availability.id)
  if neg =~ /not/
    meeting.should be_nil
  else
    meeting.should_not be_nil
  end
end

