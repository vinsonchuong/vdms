class MeetingsController < ApplicationController
  
  #before_filter :current_user_is_staff?, :only => [:tweak, :apply_tweaks, :create_all]
  before_filter :schedule_empty?, :except => :create_all

  # GET /meetings/
  # If called with a faculty_id, show that faculty's meetings
  # If called with an admit_id, show that admit's meetings
  # If neither, show the master schedule of meetings
  def index
    params[:host_id] ? for_faculty(params[:host_id]) :
      params[:visitor_id] ? for_admit(params[:visitor_id]) :
      master
  end

  # Show the master schedule
  # GET /meetings/master
  def master
    @settings = Settings.instance
    @hosts = Host.all
  end

  # Show meetings statistics
  # GET /meetings/statistics
  def statistics
    event = Event.find(params[:event_id])
    @visitors = Visitor.all
    @hosts = Host.all
    @unsatisfied_visitors = @visitors.select {|a| a.meetings.count < event.unsatisfied_visitor_threshold}
    @unsatisfied_hosts = @hosts.map {|f| [f, f.mandatory_visitors - f.meetings.map(&:visitor)]}.reject {|f, a| a.empty?}
    @visitors_with_unsatisfied_rankings = @visitors.map do |admit|
      meeting_faculty = admit.meetings.map(&:host)
      [admit, admit.rankings.reject {|r| meeting_faculty.include?(r.rankable)}]
    end.reject {|a, r| r.empty?}
    @hosts_with_unsatisfied_rankings = @hosts.map do |faculty|
      meeting_admits = faculty.meetings.map(&:visitor)
      [faculty, faculty.rankings.reject {|r| meeting_admits.include?(r.rankable)}]
    end.reject {|f, r| r.empty?}
  end

  # Show the admit schedule
  # GET /meetings/print_admits
  def print_admits
    @event = Event.find(params[:event])
    @admits = Visitor.all.reject {|a| a.meetings.empty?}
    @one_per_page = params['one_per_page'].to_b
  end

  # Show the faculty schedule
  # GET /meetings/print_faculty
  def print_faculty
    @faculty = Host.all.reject {|f| f.meetings.empty?}
    @one_per_page = params['one_per_page'].to_b
  end

  # Show schedule for admit
  # GET /people/admits/1/meetings
  def for_admit(admit_id)
    @admit = Visitor.find(admit_id)
    render :action => 'for_admit'
  end

  # Show schedule for faculty
  # GET /people/faculty/1/meetings
  def for_faculty(faculty_id)
    @faculty = Host.find(faculty_id)
    render :action => 'for_faculty'
  end

  # Tweak the schedule for faculty (ie, show editable view) - for staff only
  def tweak
    @faculty = Host.find(params[:host_id])
    @max_admits = @faculty.max_visitors_per_meeting
    @faculty.availabilities.each do |availability|
      (@max_admits - availability.meetings.count).times {availability.meetings.build}
    end
    @all_admits = Visitor.all
  end

  # Save the tweaks to a faculty meeting schedule - for staff only
  def apply_tweaks
    @faculty = Host.find(params[:host_id])

    if @faculty.update_attributes(params[:host])
      flash[:notice] = 'Success!'
    else
      flash[:alert] = 'Failure'
    end
    redirect_to master_meetings_path
  end
  
  # Run the scheduler
  # POST /meetings/create_all
  def create_all
    if Event.find(params[:event_id]).disable_scheduler
      flash[:alert] = "The staff have disabled automatic scheduler generation."
      redirect_to event_meetings_path(:event_id => params[:event_id])
      return
    end
    begin
      Meeting.generate()
      flash[:notice] = "New schedule successfully generated."
    rescue Exception => e
      flash[:alert] = "New schedule could NOT be generated: #{e.message}"
    end
    redirect_to event_meetings_path(:event_id => params[:event_id])
  end

  private

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
