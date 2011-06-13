class MeetingsController < ApplicationController
  
  before_filter :current_user_is_staff?, :only => [:tweak, :apply_tweaks, :create_all]
  before_filter :schedule_empty?, :except => :create_all

  # GET /meetings/
  # If called with a faculty_id, show that faculty's meetings
  # If called with an admit_id, show that admit's meetings
  # If neither, show the master schedule of meetings
  def index
    params[:faculty_id] ? for_faculty(params[:faculty_id]) :
      params[:admit_id] ? for_admit(params[:admit_id]) :
      master
  end

  # Show the master schedule
  # GET /meetings/master
  def master
    available_faculty = Faculty.all.select {|f| f.time_slots.select(&:available).count > 0}
    sorted_faculty = available_faculty.sort_by {|f| [-f.time_slots.select(&:available).count, f.last_name, f.first_name]}
    @meetings_by_faculty = sorted_faculty.map {|f| [f, f.time_slots.map {|t| f.meeting_for(t.begin)}]}
    @times = TimeSlot.all.map(&:begin).uniq.sort!
  end

  # Show meetings statistics
  # GET /meetings/statistics
  def statistics
    settings = Settings.instance
    @admits = Admit.by_name
    @faculty = Faculty.by_name
    @unsatisfied_admits = @admits.select {|a| a.meetings.count < settings.unsatisfied_admit_threshold}
    @unsatisfied_faculty = @faculty.map {|f| [f, f.mandatory_admits - f.meetings.map(&:admits).flatten]}.reject {|f, a| a.empty?}
    @admits_with_unsatisfied_rankings = @admits.map do |admit|
      meeting_faculty = admit.meetings.map(&:faculty)
      [admit, admit.faculty_rankings.reject {|r| meeting_faculty.include?(r.faculty)}]
    end.reject {|a, r| r.empty?}
    @faculty_with_unsatisfied_rankings = @faculty.map do |faculty|
      meeting_admits = faculty.meetings.map(&:admits).flatten
      [faculty, faculty.admit_rankings.reject {|r| meeting_admits.include?(r.admit)}]
    end.reject {|f, r| r.empty?}
  end

  # Show the admit schedule
  # GET /meetings/print_admits
  def print_admits
    @admits = Admit.by_name.reject {|a| a.meetings.empty?}
    @one_per_page = params['one_per_page'].to_b
  end

  # Show the faculty schedule
  # GET /meetings/print_faculty
  def print_faculty
    @times = TimeSlot.all.map(&:begin).uniq.sort!
    @faculty = Faculty.by_name.reject {|f| f.meetings.empty?}
    @one_per_page = params['one_per_page'].to_b
  end

  # Show schedule for admit
  # GET /people/admits/1/meetings
  def for_admit(admit_id)
    @admit = Admit.find(admit_id)
    render :action => 'for_admit'
  end

  # Show schedule for faculty
  # GET /people/faculty/1/meetings
  def for_faculty(faculty_id)
    @faculty = Faculty.find(faculty_id)
    @times = TimeSlot.all.map(&:begin).uniq.sort!
    render :action => 'for_faculty'
  end

  # Tweak the schedule for faculty (ie, show editable view) - for staff only
  def tweak
    @times = TimeSlot.all.map(&:begin).uniq.sort!
    @faculty = Faculty.find(params[:faculty_id])
    @max_admits = @faculty.max_admits_per_meeting
    @meetings = @faculty.meetings.sort_by(&:time)
    @all_admits = Admit.all.sort_by(&:last_name)
  end

  # Save the tweaks to a faculty meeting schedule - for staff only
  def apply_tweaks
    flash[:alert] = ''
    params.delete_if { |k,v| v.blank? }
    messages = delete_meetings(params.keys)
    messages += add_meetings(params)
    flash[:alert] = messages.join('<br/>')
    redirect_to master_meetings_path
  end
  
  # Run the scheduler
  # POST /meetings/create_all
  def create_all
    if Settings.instance.disable_scheduler
      flash[:alert] = "The staff have disabled automatic scheduler generation."
      redirect_to master_meetings_path
      return
    end
    begin
      Meeting.generate()
      flash[:notice] = "New schedule successfully generated."
    rescue Exception => e
      flash[:alert] = "New schedule could NOT be generated: #{e.message}"
    end
    redirect_to master_meetings_path
  end

  private

  def delete_meetings(keys)
    messages = []
    keys.each do |key|
      if key =~ /^remove_(\d+)_(\d+)$/
        begin
          meeting = Meeting.find($2)
          admit = Admit.find($1)
          meeting.remove_admit!(admit)
          messages << "#{admit.full_name} removed from #{meeting.time.strftime('%I:%M%p')} meeting."
        rescue Exception => e
          messages << "Can't remove admit #{admit} from meeting #{meeting}: #{e.message}"
        end
      end
    end
    messages
  end

  def add_meetings(params)
    messages = []
    params.each_pair do |menu_name,admit|
      if menu_name =~ /^add_(\d+)_\d+$/
        begin
          meeting = Meeting.find($1)
          admit = Admit.find(admit)
          meeting.add_admit!(admit)
          messages << "#{admit.full_name} added to #{meeting.time.strftime('%I:%M%p')} meeting."
        rescue Exception => e
          messages << "#{admit.full_name if admit} NOT added to #{meeting.time.strftime('%I:%M%p')} meeting: #{e.message}"
        end
      end
    end
    messages
  end

  def current_user_is_staff?
    unless @current_user && @current_user.class.name == 'Staff'
      flash[:alert] = 'Only Staff users may perform this action.'
      redirect_to home_path
    end
  end

  def schedule_empty?
    if Meeting.count.zero?
      flash[:alert] = t('meetings.master.if_empty')
    end
    true
  end
end
