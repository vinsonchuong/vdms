Given /^my first admit has the following meeting schedule:$/ do |admit_meeting_schedules|
  admit_meeting_schedules.hashes.each do |admit_meeting_schedule|
    @admit.meetings.create(
      :time => admit_meeting_schedule[:time],
      :room => admit_meeting_schedule[:room].to_s,
      :faculty_id => admit_meeting_schedule[:faculty_id].to_i
    )
  end
end

Given /^the following (\d+)-minute meetings are scheduled starting at (.*):$/ do |slot_length,base,meetings|
  # prepopulate with empty meeting slots
  base_time = Time.zone.parse(base)
  slot_length = slot_length.to_i.minutes
  @faculty = nil
  meetings.hashes.each do |meeting|
    unless meeting[:faculty].blank? # if blank, continue using same faculty as before
      @faculty = Faculty.find_by_first_name_and_last_name(*(meeting[:faculty].split(/ /)))
    end
    (0..meetings.column_names.length-2).each do |timeslot|
      admit_name = meeting["time_#{timeslot}".to_sym]
      next if admit_name.blank?
      admit =  Admit.find_by_first_name_and_last_name(*(admit_name.split(/\s+/)))
      time = base_time + slot_length * timeslot
      @faculty.available_times.create!(:begin => time, :end => time+slot_length-1, :available => true) unless @faculty.available_at?(time)
      puts "#{@faculty.full_name} is avail at #{time}: #{@faculty.available_at?(time)}"
      admit.available_times.create!(:begin => time, :end => time+slot_length, :available => true) unless admit.available_at?(time)
      # if already a meeting at this time, add the admit to it; else create new mtg
      puts "Doing admit #{admit.full_name}"
      if (m = @faculty.meetings.find_by_time(time))
        puts "Found meeting #{m}, valid #{m.valid?}"
      else
        m = @faculty.meetings.create!(:time => time, :room => 'Default')
        puts "Created meeting: #{m}, valid: #{m.valid?}"
      end
      m.admits << admit
      # make sure faculty's max admits/slot is bumped up to allow this
      @faculty.max_admits_per_meeting = m.admits.length
      @faculty.save!
      m.save!
    end
  end
end
