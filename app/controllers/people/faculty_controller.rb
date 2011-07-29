class FacultyController < PeopleController
  before_filter :get_areas_and_divisions, :only => [:new, :edit, :create, :update]

  # GET /people/faculty
  def index
    @faculty = Faculty.by_name
  end

  # GET /people/faculty/1/new
  def new
    @faculty_instance = (@current_user.new_record?) ? @current_user : Faculty.new
  end

  # GET /people/faculty/1/edit_availability
  def edit_availability
    settings = Settings.instance
    @faculty_instance = Faculty.find(params[:id])
    #@faculty_instance.build_time_slots(settings.meeting_times(@faculty_instance.division), settings.meeting_length, settings.meeting_gap)

    if Settings.instance.disable_faculty && @current_user.class == Faculty
      flash[:alert] = t('people.faculty.edit_availability.disabled')
    end

    @origin_action = 'edit_availability'
    @redirect_action = 'edit_availability'
  end

  private

  def get_model
    @model = Faculty
    @collection = 'faculty'
    @instance = 'faculty_instance'
  end

  def get_areas_and_divisions
    settings = Settings.instance
    @areas = settings.areas.map {|k, v| [v, k]}.sort!
    @divisions = settings.divisions.map {|k, v| [v, k]}.sort!
  end
end
