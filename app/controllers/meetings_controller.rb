class MeetingsController < ApplicationController

  before_filter :current_user_is_staff?, :only => [:tweak, :apply_tweaks, :create_all]
  before_filter :schedule_empty?

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
    meetings = Meeting.all
    @meetings_by_faculty = meetings.group_by(&:faculty)
    @times = meetings.map(&:time).uniq.sort
  end

  # Show schedule for admit
  # GET /people/admits/1/meetings

  def for_admit(admit_id)
    @admit = Admit.find(admit_id)
    @admit_meetings = @admit.meetings.sort_by(&:time)
    render :action => 'for_admit'
  end

  # Show schedule for faculty
  # GET /people/faculty/1/meetings
  def for_faculty(faculty_id)
    @faculty = Faculty.find(faculty_id)
    @faculty_meetings = @faculty.meetings.sort_by(&:time)
    render :action => 'for_faculty'
  end

  # Tweak the schedule for faculty (ie, show editable view) - for staff only
  def tweak
    @faculty = Faculty.find(params[:faculty_id])
    @max_admits = @faculty.max_admits_per_meeting
    @meetings = @faculty.meetings.sort_by(&:time)
  end

  # Save the tweaks to a faculty meeting schedule - for staff only
  def apply_tweaks
  end
  
  # Run the scheduler
  # POST /meetings/create_all
  def create_all
    Meeting.generate()
    redirect_to master_meetings_path
  end

  private

  def current_user_is_staff?
    unless @current_user && @current_user.class.name == 'Staff'
      flash[:notice] = 'Only Staff users may perform this action.'
      redirect_to home_path
    end
  end

  def schedule_empty?
    if Meeting.count.zero?
      flash[:notice] = t('meetings.master.if_empty')
    end
    true
  end
end
