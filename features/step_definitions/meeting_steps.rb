Given /^"(.*) (.*)" is available at (.*)$/ do |first,last,time|
  time = Time.zone.parse(time)
  p = Person.find_by_first_name_and_last_name(first,last)
  p.available_times.create!(:begin => time, :end => time + @slot_length, :available => true)
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
      @faculty.available_times.create!(:begin => time, :end => time+@slot_length-1, :available => true) unless @faculty.available_at?(time)
      admit.available_times.create!(:begin => time, :end => time+@slot_length, :available => true) unless admit.available_at?(time)
      # if already a meeting at this time, add the admit to it; else create new mtg
      m = @faculty.meetings.find_by_time(time) ||
        @faculty.meetings.create!(:time => time, :room => 'Default')
      m.admits << admit
      # make sure faculty's max admits/slot is bumped up to allow this
      @faculty.max_admits_per_meeting = 1 + m.admits.length
      @faculty.save!
      m.save!
    end
  end
end

When /^I check the remove box for admit "(.*) (.*)" at (.*)/ do |first,last,time|
  @admit = Admit.find_by_first_name_and_last_name(first,last)
  @time = Time.zone.parse(time)
  @meeting = Meeting.find_all_by_time(@time).detect { |m| m.admits.include?(@admit) }
  When %Q{I check "remove_#{@admit.id}_#{@meeting.id}"}
end

When /^I select "(.*)" from the menu for the (.*) meeting with "(.*) (.*)"$/ do |admit,time,fac_first,fac_last|
  @time = Time.zone.parse(time)
  @faculty = Faculty.find_by_first_name_and_last_name(fac_first,fac_last)
  meeting = @faculty.meetings.find_by_time(@time)
  select(admit, :from => "add_#{meeting.id}_#{@faculty.max_admits_per_meeting}")
end

Then /^I should (not |)?have a meeting with "(.*) (.*)" at (.*)/ do |neg,first,last,time|
  @admit = Admit.find_by_first_name_and_last_name(first,last)
  @time = Time.zone.parse(time)
  meeting = Meeting.find_all_by_time(@time).detect { |m| m.admits.include?(@admit) }
  if neg =~ /not/
    meeting.should be_nil
  else
    meeting.should_not be_nil
  end
end

