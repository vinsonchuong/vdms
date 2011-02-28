class MeetingsController < ApplicationController

  before_filter :current_user_is_staff?, :only => [:edit, :update, :create_all]

  # GET /meetings/
  # If called with a faculty_id, show that faculty's meetings
  # If called with an admit_id, show that admit's meetings
  def index
    params[:faculty_id] ? for_faculty(params[:faculty_id]) :
      params[:admit_id] ? for_admit(params[:admit_id]) :
      master
  end

  # Show the master schedule
  def master
    meetings = Meeting.all
    @meetings_by_faculty = meetings.group_by(&:faculty)
    @times = meetings.map(&:time).uniq.sort
  end

  # POST /meetings/create_all
  def create_all
    Meeting.generate()
    redirect_to master_meetings_path
  end

  # Show schedule for admit
  # GET /people/admits/1/meetings

  def for_admit(admit_id)
    @admit = Admit.find(admit_id)
    @name = @admit.full_name
    @admit_meetings = @admit.meetings.sort_by(&:time)
    render :action => 'for_admit'
  end

  def for_faculty(faculty_id)
    @faculty = Faculty.find(faculty_id)
    @name = @faculty.full_name
    @faculty_meetings = @faculty.meetings.sort_by(&:time)
    render :action => 'for_faculty'
  end

  private

  def current_user_is_staff?
    unless @current_user && @current_user.class.name == 'Staff'
      flash[:notice] = 'Only Staff users may perform this action.'
      redirect_to home_path
    end
  end

end
